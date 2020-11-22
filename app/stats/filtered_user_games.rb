class FilteredUserGames
  attr_reader :games

  # TODO: Flesh this out into actual code.
  # TODO: Use the temp score-ordering code as an example.
  # pa: date_played
  # rr: rerun
  # sd: show_date
  # pt: play_type
  # TODO: cs: round_one_score + 2 * round_two_score
  # ro: round_one_score
  # rt: round_two_score
  # TODO: dr: CASE WHEN dd1_result = 7 THEN 1 ELSE 0 END +
  #                     dd2a_result
  #                     dd2b_result
  # TODO: dw: CASE WHEN dd1_result IN (5, 6) THEN 1 ELSE 0 END +
  #                     dd2a_result
  #                     dd2b_result
  # fi: final_result
  #
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
