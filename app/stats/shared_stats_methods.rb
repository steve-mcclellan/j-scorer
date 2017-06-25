module SharedStatsMethods
  def valid_types?(play_types)
    return false unless play_types.is_a?(Array)
    play_types.push('none') if play_types.empty?
    play_types.all? { |type| VALID_TYPE_INPUTS.include?(type) }
  end

  def quotient(numerator, denominator)
    return nil if denominator.zero?
    numerator.fdiv(denominator)
  end

  # rubocop:disable MethodLength
  # def add_clue_to_stats(stats_hash, result_code, clue_value)
  #   case result_code.to_i
  #   when 1
  #     stats_hash[:wrong] += 1
  #     stats_hash[:score] -= clue_value
  #     stats_hash[:possible_score] += clue_value
  #   when 2
  #     stats_hash[:pass] += 1
  #     stats_hash[:possible_score] += clue_value
  #   when 3
  #     stats_hash[:right] += 1
  #     stats_hash[:score] += clue_value
  #     stats_hash[:possible_score] += clue_value
  #   when 5, 6
  #     stats_hash[:dd_wrong] += 1
  #     stats_hash[:possible_score] += clue_value
  #   when 7
  #     stats_hash[:dd_right] += 1
  #     stats_hash[:score] += clue_value
  #     stats_hash[:possible_score] += clue_value
  #   end
  # end
  # # rubocop:enable MethodLength
end
