class Game < ApplicationRecord
  belongs_to :user, inverse_of: :games, touch: true
  has_many :sixths, inverse_of: :game, dependent: :destroy
  has_one :final, inverse_of: :game, dependent: :destroy

  accepts_nested_attributes_for :sixths, :final

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope { order(date_played: :desc) }

  before_validation :add_default_date_played
  before_validation :set_game_id, on: :update

  validates :user, presence: true
  validates :show_date, presence: true
  validates :date_played, presence: true
  validates :game_id, presence: true, uniqueness: { scope: :user_id },
                                      on: :update
  validates :play_type, presence: true, inclusion: { in: PLAY_TYPES.keys }

  before_create :set_game_id

  after_save :set_dd_results

  default_values show_date:   -> { Time.zone.today },
                 date_played: -> { Time.zone.now }

  def to_param
    game_id.to_s.parameterize
  end

  def adjusted_round_one_score
    round_one_score * CURRENT_TOP_ROW_VALUES[0]
  end

  def adjusted_round_two_score
    round_two_score * CURRENT_TOP_ROW_VALUES[1]
  end

  def adjusted_game_score
    adjusted_round_one_score + adjusted_round_two_score
  end

  def final_symbol
    case final_result
    when 0 then ''
    when 1 then '✘'
    when 3 then '✓'
    else '?'
    end
  end

  def dds_right
    all_dd_results.count { |code| code == 7 }
  end

  def dds_wrong
    all_dd_results.count { |code| [5, 6].include? code }
  end

  private

  def all_dd_results
    [dd1_result, dd2a_result, dd2b_result]
  end

  def set_dd_results
    dd_summary = { round_one: round_one_categories.map(&:dd_result).compact,
                   round_two: round_two_categories.map(&:dd_result).compact }

    # rubocop:disable SkipsModelValidations
    update_columns(
      dd1_result: dd_summary[:round_one][0] || 0,
      dd2a_result: dd_summary[:round_two][0] || 0,
      dd2b_result: dd_summary[:round_two][1] || 0
    )
    # rubocop:enable SkipsModelValidations
  end

  # If the show date is unused as a game_id, use that. Otherwise, try the show
  # date with "-1" appended. If that's taken, try "-2", ad infinitum.
  def set_game_id
    return if game_id

    0.upto(Float::INFINITY) do |num|
      g_id = (num.zero? ? show_date.to_s : "#{show_date}-#{num}")
      self.game_id = g_id and break if user.games.find_by(game_id: g_id).nil?
    end
  end

  def add_default_date_played
    self.date_played = Time.new(0, 12, 31, 12, 0, 0, 0) if date_played.nil?
  end
end
