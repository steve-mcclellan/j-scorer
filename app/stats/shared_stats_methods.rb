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

  def validate_query_inputs(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
  end

  def format_play_types_for_sql(play_types)
    play_types.map { |x| "'#{x}'" }.join(', ')
  end
end
