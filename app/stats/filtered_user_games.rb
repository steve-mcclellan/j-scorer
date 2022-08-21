class FilteredUserGames
  attr_reader :games

  COLUMN_NAMES = {
    'pa' => 'date_played',
    'rr' => 'rerun',
    'sd' => 'show_date',
    'pt' => 'play_type',
    'cs' => 'coryat',
    'ro' => 'round_one_score',
    'rt' => 'round_two_score',
    'at' => 'attempts',
    'co' => 'correct',
    'in' => 'incorrect',
    'cp' => 'correct_percentage',
    'dr' => 'dd_right',
    'dw' => 'dd_wrong',
    'fi' => 'final_result'
  }.freeze

  dd_right_sql =
    "
      CASE WHEN dd1_result = 7 THEN 1 ELSE 0 END +
      CASE WHEN dd2a_result = 7 THEN 1 ELSE 0 END +
      CASE WHEN dd2b_result = 7 THEN 1 ELSE 0 END
    "

  total_right_sql = "clues_right + #{dd_right_sql}"

  dd_wrong_sql =
    "
      CASE WHEN dd1_result IN (5, 6) THEN 1 ELSE 0 END +
      CASE WHEN dd2a_result IN (5, 6) THEN 1 ELSE 0 END +
      CASE WHEN dd2b_result IN (5, 6) THEN 1 ELSE 0 END
    "

  total_wrong_sql = "clues_wrong + #{dd_wrong_sql}"

  NONCE_COLUMNS = {
    'cs' => 'round_one_score + 2 * round_two_score AS coryat',
    'at' => 'clues_right + clues_wrong AS attempts',
    'co' => "#{total_right_sql} AS correct",
    'in' => "#{total_wrong_sql} AS incorrect",
    'cp' => "CASE WHEN #{total_right_sql} = 0 AND #{total_wrong_sql} = 0 THEN -1 ELSE (#{total_right_sql})::numeric / (#{total_right_sql} + #{total_wrong_sql}) END AS correct_percentage",
    'dr' => "#{dd_right_sql} AS dd_right",
    'dw' => "#{dd_wrong_sql} AS dd_wrong"
  }.freeze

  DIRECTIONS = { '0' => 'ASC', '1' => 'DESC' }.freeze

  def initialize(user, params, filters, play_types)
    @filters = filters
    @play_types = play_types

    @games = user.games
    filter_games unless params[:allgames] == 'true'
    order_games(params[:sort_order])
  end

  private

  def filter_games
    filter_sql = User.filter_sql(@filters, '')
    play_type_sql = 'play_type IN '\
                 "(#{@play_types.map { |x| "'#{x}'" }.join(', ')})"
    @games = @games.where("#{play_type_sql}#{filter_sql}")
  end

  def order_games(sort_order_string)
    return if sort_order_string.blank?

    @select_extras = ''
    @order_clause = ''

    sort_order_string.split(',').each { |ordering| process_ordering(ordering) }

    @games = @games.select("*#{@select_extras}") if @select_extras
    @games = @games.unscope(:order).order(@order_clause[0..-2]) if @order_clause
  end

  def process_ordering(ordering_string)
    column_abbr = ordering_string[0..-2]
    column_name = COLUMN_NAMES[column_abbr]
    direction = DIRECTIONS[ordering_string[-1]]
    return if column_name.nil? || direction.nil?

    select_extra = NONCE_COLUMNS[column_abbr]
    @select_extras += ", #{select_extra}" if select_extra
    @order_clause += "#{column_name} #{direction},"
  end
end
