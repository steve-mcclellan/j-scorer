class FilterSQLGenerator
  attr_reader :sql

  def initialize(filters, table_prefix)
    @filters = filters
    @prefix = table_prefix
    @sql = show_date_filters + date_played_filters + rerun_filter
  end

  private

  def show_date_filters
    send(subclause_getter(@filters[:show_date_preposition]), 'show_date')
  end

  def date_played_filters
    send(subclause_getter(@filters[:date_played_preposition]), 'date_played')
  end

  def rerun_filter
    case @filters[:rerun_status]
    when 'first' then " AND NOT #{@prefix}rerun"
    when 'rerun' then " AND #{@prefix}rerun"
    else ''
    end
  end

  def subclause_getter(preposition)
    case preposition
    when 'sinceBeg' then :since_beginning_subclause
    when 'inLast' then :in_last_subclause
    when 'since' then :since_subclause
    when 'from' then :from_subclause
    else :default_subclause
    end
  end

  def since_beginning_subclause(type)
    range_subclause(type,
                    @filters[(type + '_beginning').to_sym],
                    nil,
                    @filters[(type + '_reverse').to_sym])
  end

  def since_subclause(type)
    range_subclause(type,
                    @filters[(type + '_from').to_sym],
                    nil,
                    @filters[(type + '_reverse').to_sym])
  end

  def from_subclause(type)
    range_subclause(type,
                    @filters[(type + '_from').to_sym],
                    @filters[(type + '_to').to_sym],
                    @filters[(type + '_reverse').to_sym])
  end

  def range_subclause(type, from, to, reverse)
    d1, d2 = sanitize_dates(from, to)
    return (reverse ? ' AND FALSE' : '') if d1.blank? && d2.blank?
    subsubclause1 = "#{@prefix}#{type} #{reverse ? '<' : '>='} '#{d1}'"
    return " AND #{subsubclause1}" if d2.blank?
    subsubclause2 = "#{@prefix}#{type} #{reverse ? '>' : '<='} '#{d2}'"
    " AND (#{subsubclause1} #{reverse ? 'OR' : 'AND'} #{subsubclause2})"
  end

  def in_last_subclause(type)
    n = sanitize_number(@filters[(type + '_last_number').to_sym])
    u = sanitize_unit(@filters[(type + '_last_unit').to_sym])
    r = @filters[(type + '_reverse').to_sym]
    return (r ? '' : ' AND FALSE') if n.blank? || u.blank?
    " AND #{@prefix}#{type} #{r ? '<' : '>='} NOW() - INTERVAL '#{n} #{u}'"
  end

  def default_subclause(_type)
    ''
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
