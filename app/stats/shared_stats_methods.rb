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

  def coalesce_filters(filters)
    filters.gsub(/g\.(\S*)/, 'COALESCE(gOne.\\1, gTwo.\\1)')
  end

  # rubocop:disable IdenticalConditionalBranches
  def result_count(table, value, weight = false)
    cond = value.is_a?(Array) ? "IN (#{value.join(', ')})" : "= #{value}"
    "
    (CASE WHEN #{table}.result1 #{cond} THEN #{weight ? 1 : 1} ELSE 0 END) +
    (CASE WHEN #{table}.result2 #{cond} THEN #{weight ? 2 : 1} ELSE 0 END) +
    (CASE WHEN #{table}.result3 #{cond} THEN #{weight ? 3 : 1} ELSE 0 END) +
    (CASE WHEN #{table}.result4 #{cond} THEN #{weight ? 4 : 1} ELSE 0 END) +
    (CASE WHEN #{table}.result5 #{cond} THEN #{weight ? 5 : 1} ELSE 0 END)
    "
  end
  # rubocop:enable IdenticalConditionalBranches
end
