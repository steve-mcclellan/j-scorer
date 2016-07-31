class Game < ActiveRecord::Base
  belongs_to :user, inverse_of: :games, touch: true
  has_many :sixths, inverse_of: :game, dependent: :destroy
  has_one :final, inverse_of: :game, dependent: :destroy

  accepts_nested_attributes_for :sixths, :final

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope { order(date_played: :desc) }

  validates :user, presence: true
  validates :show_date, presence: true, uniqueness: { scope: :user_id }

  default_values show_date:   -> { Time.zone.today },
                 date_played: -> { Time.zone.now }

  def to_param
    show_date.to_s.parameterize
  end

  # def create_categories!
  #   1.upto(6) { |i| round_one_categories.create!(board_position: i) }
  #   1.upto(6) { |i| round_two_categories.create!(board_position: i) }
  #   create_final!
  # end

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

  private

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
