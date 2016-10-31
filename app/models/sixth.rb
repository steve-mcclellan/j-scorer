class Sixth < ActiveRecord::Base
  belongs_to :game, inverse_of: :sixths, touch: true

  validates :game, presence: true
  validates :board_position,
            presence: true,
            inclusion: { in: [1, 2, 3, 4, 5, 6] },
            uniqueness: { scope: [:game_id, :type],
                          message: 'already exists' }

  default_scope { order(type: :asc, board_position: :asc) }

  include Topicable

  def self.types
    %w(RoundOneCategory RoundTwoCategory)
  end

  scope :round_one_categories, -> { where(type: 'RoundOneCategory') }
  scope :round_two_categories, -> { where(type: 'RoundTwoCategory') }

  def top_row_value
    return CURRENT_TOP_ROW_VALUES[0] if type == 'RoundOneCategory'
    return CURRENT_TOP_ROW_VALUES[1] if type == 'RoundTwoCategory'
    nil
  end

  def summary
    stats = { right: 0, wrong: 0, pass: 0, score: 0, possible_score: 0,
              dd_position: nil, dd_result: nil }
    results = [result1, result2, result3, result4, result5]

    results.each_with_index do |result_code, index|
      add_clue_stats(stats, result_code, index + 1)
    end

    stats[:score] *= top_row_value
    stats[:possible_score] *= top_row_value
    stats
  end

  private

  def add_clue_stats(stats, result_code, row_number)
    update_stats(stats, result_code, row_number)
    update_dd_stats(stats, result_code, row_number) if result_code > 4
    stats[:possible_score] += row_number unless [0, 4].include? result_code
  end

  def update_stats(stats, result_code, row_number)
    case result_code
    when 1, 5 then stats[:wrong] += 1
    when 2, 6 then stats[:pass]  += 1
    when 3, 7 then stats[:right] += 1
    end

    case result_code
    when 1 then stats[:score] -= row_number
    when 3, 7 then stats[:score] += row_number
    end
  end

  def update_dd_stats(stats, result_code, row_number)
    stats[:dd_position] = row_number
    stats[:dd_result] = result_code
  end
end
