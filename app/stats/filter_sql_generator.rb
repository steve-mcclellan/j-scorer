class FilterSQLGenerator
  attr_reader :sql

  def initialize(filters)
    @filters = filters
    @sql = show_date_filters + date_played_filters
    @sql
  end

  private

  def show_date_filters
    case @filters[:show_date_preposition]
    when 'sinceBeg' then range_subclause('show_date',
                                         @filters[:show_date_beginning],
                                         nil,
                                         @filters[:show_date_reverse])
    when 'inLast' then in_last_subclause('show_date',
                                         @filters[:show_date_last_number],
                                         @filters[:show_date_last_unit],
                                         @filters[:show_date_reverse])
    when 'since' then range_subclause('show_date',
                                      @filters[:show_date_from],
                                      nil,
                                      @filters[:show_date_reverse])
    when 'from' then range_subclause('show_date',
                                     @filters[:show_date_from],
                                     @filters[:show_date_to],
                                     @filters[:show_date_reverse])
    else ''
    end
  end

  def date_played_filters
    ''
  end

  def range_subclause(type, from, to, reverse)
    d1, d2 = sanitize_dates(from, to)
    return (reverse ? ' AND FALSE' : '') if d1.blank? && d2.blank?
    subsubclause1 = "#{type} #{reverse ? '<' : '>='} '#{d1}'"
    return " AND #{subsubclause1}" if d2.blank?
    subsubclause2 = " #{type} #{reverse ? '>' : '<='} '#{d2}'"
    " AND (#{subsubclause1} #{reverse ? 'OR' : 'AND'} #{subsubclause2})"
  end

  def in_last_subclause(type, number, unit, reverse)
    n = sanitize_number(number)
    u = sanitize_unit(unit)
    return (reverse ? '' : ' AND FALSE') if n.blank? || u.blank?
    " AND #{type} #{reverse ? '<' : '>='} NOW() - INTERVAL '#{n} #{u}'"
  end

  def sanitize_date(date)
    return '' if date.blank?
    begin
      date.strftime('%F')
    rescue NoMethodError
      Date.parse(date).strftime('%F')
    end
  rescue ArgumentError
    ''
  end

  def sanitize_dates(from, to)
    d1 = sanitize_date(from)
    d2 = sanitize_date(to)
    return d1, '' if d2.blank?
    return d2, '' if d1.blank?
    d1 < d2 ? [d1, d2] : [d2, d1]
  end

  def sanitize_number(number)
    return '' if number.blank?
    return number.to_f.to_s if number.to_s.include?('.')
    number.to_i.to_s
  end

  def sanitize_unit(unit)
    return '' if unit.blank?
    { d: 'days', w: 'weeks', m: 'months', y: 'years' }[unit.to_sym] || ''
  end
end
