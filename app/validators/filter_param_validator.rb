class FilterParamValidator < ActiveModel::Validator
  VALID_PREPOSITIONS = %w(sinceBeg inLast since from).freeze
  VALID_TIME_UNITS = %w(d w m y).freeze
  VALID_WEIGHTINGS = %w(equal half-life).freeze

  # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength
  # rubocop:disable PerceivedComplexity, GuardClause
  def validate(record)
    unless valid_preposition?(record.show_date_preposition)
      record.errors[:show_date_preposition] << 'Invalid show date preposition'
    end

    unless valid_date?(record.show_date_beginning)
      record.errors[:show_date_beginning] << 'Invalid show date beginning'
    end

    unless valid_unit?(record.show_date_last_unit)
      record.errors[:show_date_last_unit] << 'Invalid show date unit'
    end

    unless valid_date?(record.show_date_from)
      record.errors[:show_date_from] << 'Invalid show date from date'
    end

    unless valid_date?(record.show_date_to)
      record.errors[:show_date_to] << 'Invalid show date to date'
    end

    unless valid_weighting?(record.show_date_weight)
      record.errors[:show_date_weight] << 'Invalid show date weighting'
    end

    unless valid_half_life?(record.show_date_half_life)
      record.errors[:show_date_half_life] << 'Invalid show date half-life'
    end

    unless valid_preposition?(record.date_played_preposition)
      record.errors[:date_played_preposition] << 'Invalid date played prepos.'
    end

    unless valid_date?(record.date_played_beginning)
      record.errors[:date_played_beginning] << 'Invalid date played beginning'
    end

    unless valid_unit?(record.date_played_last_unit)
      record.errors[:date_played_last_unit] << 'Invalid date played unit'
    end

    unless valid_date?(record.date_played_from)
      record.errors[:date_played_from] << 'Invalid date played from date'
    end

    unless valid_date?(record.date_played_to)
      record.errors[:date_played_to] << 'Invalid date played to date'
    end

    unless valid_weighting?(record.date_played_weight)
      record.errors[:date_played_weight] << 'Invalid date played weighting'
    end

    unless valid_half_life?(record.date_played_half_life)
      record.errors[:date_played_half_life] << 'Invalid date played half-life'
    end
  end
  # rubocop:enable AbcSize, CyclomaticComplexity, MethodLength
  # rubocop:enable PerceivedComplexity, GuardClause

  private

  def valid_preposition?(prep)
    prep.nil? || VALID_PREPOSITIONS.include?(prep)
  end

  def valid_date?(date)
    return true if date.nil?
    # return false unless date =~ /\d+-\d+-\d+/
    # parsed_date = Date.parse(date)
    # Date.new(1, 1, 1) <= parsed_date && parsed_date <= Date.new(9999, 12, 31)
    Date.new(1, 1, 1) <= date && date <= Date.new(9999, 12, 31)
  end

  def valid_unit?(unit)
    unit.nil? || VALID_TIME_UNITS.include?(unit)
  end

  def valid_weighting?(weighting)
    weighting.nil? || VALID_WEIGHTINGS.include?(weighting)
  end

  def valid_half_life?(half_life)
    half_life != 0
  end
end
