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
    'dr' => 'dd_right',
    'dw' => 'dd_wrong',
    'fi' => 'final_result'
  }.freeze

  def dd_counter(condition, column_name)
    "
    CASE WHEN dd1_result #{condition} THEN 1 ELSE 0 END +
    CASE WHEN dd2a_result #{condition} THEN 1 ELSE 0 END +
    CASE WHEN dd2b_result #{condition} THEN 1 ELSE 0 END AS #{column_name}
    "
  end

  NONCE_COLUMNS = {
    'cs' => 'round_one_score + 2 * round_two_score AS coryat',
    'dr' => dd_counter('= 7', 'dd_right'),
    'dw' => dd_counter('IN (5, 6)', 'dd_wrong')
  }.freeze

  def initialize(user, params, filters, play_types)
    @filters = filters
    @play_types = play_types

    @games = user.games
    filter_games unless params[:allgames] == 'true'
    order_games
  end

  private

  def filter_games
    filter_sql = User.filter_sql(@filters, '')
    play_type_sql = 'play_type IN '\
                 "(#{@play_types.map { |x| "'#{x}'" }.join(', ')})"
    @games = @games.where("#{play_type_sql}#{filter_sql}")
  end

  def order_games
    @games = @games.select('*, round_one_score + 2 * round_two_score AS score')
                   .unscope(:order).order('score DESC')
  end
end
