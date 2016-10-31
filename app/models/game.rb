class Game < ActiveRecord::Base
  belongs_to :user, inverse_of: :games, touch: true
  has_many :sixths, inverse_of: :game, dependent: :destroy
  has_one :final, inverse_of: :game, dependent: :destroy

  accepts_nested_attributes_for :sixths, :final

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope { order(date_played: :desc) }

  validates :user, presence: true
  validates :show_date, presence: true, uniqueness: { scope: :user_id }

  after_save :set_dd_results

  default_values show_date:   -> { Time.zone.today },
                 date_played: -> { Time.zone.now }

  def to_param
    show_date.to_s.parameterize
  end

  def adjusted_game_score
    (round_one_score * CURRENT_TOP_ROW_VALUES[0]) +
      (round_two_score * CURRENT_TOP_ROW_VALUES[1])
  end

  def all_category_summary
    stats = { round_one: { right: 0, wrong: 0, pass: 0, dd: [],
                           score: 0, possible_score: 0 },
              round_two: { right: 0, wrong: 0, pass: 0, dd: [],
                           score: 0, possible_score: 0 },
              final_status: final_result }
    round_one_categories.each { |cat| update_stats(stats, cat.summary, 1) }
    round_two_categories.each { |cat| update_stats(stats, cat.summary, 2) }
    stats
  end

  def final_symbol
    case final_result
    when 0 then ''
    when 1 then '&#x2718;'.html_safe
    when 3 then '&#x2713;'.html_safe
    else '?'
    end
  end

  def all_dd_results
    [dd1_result, dd2a_result, dd2b_result]
  end

  def dds_right
    all_dd_results.count { |code| code == 7 }
  end

  def dds_wrong
    all_dd_results.count { |code| [5, 6].include? code }
  end

  private

  def set_dd_results
    summary = all_category_summary

    dd1 = summary[:round_one][:dd][0]
    dd2a = summary[:round_two][:dd][0]
    dd2b = summary[:round_two][:dd][1]

    update_columns(
      dd1_result: dd1 ? dd1[1] : 0,
      dd2a_result: dd2a ? dd2a[1] : 0,
      dd2b_result: dd2b ? dd2b[1] : 0
    )
  end

  def update_stats(stats, category_summary, round)
    current_round = [0, :round_one, :round_two][round]

    [:right, :wrong, :pass].each do |stat|
      stats[current_round][stat] += category_summary[stat]
    end

    if category_summary[:dd_position]
      stats[current_round][:dd] << [category_summary[:dd_position],
                                    category_summary[:dd_result]]
    end

    stats[current_round][:score] += category_summary[:score]
    stats[current_round][:possible_score] += category_summary[:possible_score]
  end
end
