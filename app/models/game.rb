class Game < ActiveRecord::Base
  belongs_to :user, touch: true
  has_many :sixths, inverse_of: :game, dependent: :destroy
  has_one :final, inverse_of: :game, dependent: :destroy

  accepts_nested_attributes_for :sixths, :final

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope { order(date_played: :desc) }

  validates :user_id, presence: true
  validates :show_date, presence: true, uniqueness: { scope: :user_id }

  default_values show_date:   -> { Time.zone.today },
                 date_played: -> { Time.zone.now }

  def to_param
    show_date.to_s.parameterize
  end

  def topics_array
    topics_string.strip                 # Remove leading/trailing whitespace.
                 .squeeze(' ')          # Compress any consecutive spaces.
                 .gsub(/\s?,\s?/, ',')  # Remove any whitespace around commas.
                 .split(',')            # Convert to array of strings.
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
end
