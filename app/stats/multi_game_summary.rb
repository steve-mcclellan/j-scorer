class MultiGameSummary
  attr_reader :stats

  def initialize(user, play_types)
    @user = user
    @stats = { round_one: { right: 0, wrong: 0, pass: 0,
                            dd_right: 0, dd_wrong: 0,
                            score: 0, possible_score: 0 },
               round_two: { right: 0, wrong: 0, pass: 0,
                            dd_right: 0, dd_wrong: 0,
                            score: 0, possible_score: 0 },
               finals: { right: 0, wrong: 0 } }

    @games = @user.games.where(play_type: play_types)
    @games.each { |game| update_stats(game.all_category_summary) }
  end

  def total_score
    @stats[:round_one][:score] + @stats[:round_two][:score]
  end

  def games_tracked
    @game_count ||= @games.count
  end

  def average_score
    games_tracked.zero? ? nil : total_score.fdiv(games_tracked)
  end

  # Currently unused, but I might change that at some point.
  # def efficiency
  #   possible_score = @stats[:round_one][:possible_score] +
  #                    @stats[:round_two][:possible_score]
  #   return nil if possible_score.zero?
  #   total_score.fdiv(possible_score)
  # end

  private

  def update_stats(game_summary)
    [:round_one, :round_two].each do |round|
      [:right, :wrong, :pass].each do |stat|
        @stats[round][stat] += game_summary[round][stat]
      end

      add_dd_stats(game_summary, round)
      @stats[round][:score] += game_summary[round][:score]
      @stats[round][:possible_score] += game_summary[round][:possible_score]
    end

    add_final_stats(game_summary)
  end

  def add_dd_stats(game_summary, round)
    game_summary[round][:dd].each do |_row, result|
      @stats[round][:dd_right] += 1 if result == 7
      @stats[round][:dd_wrong] += 1 if [5, 6].include? result
    end
  end

  def add_final_stats(game_summary)
    @stats[:finals][:wrong] += 1 if game_summary[:final_status] == 1
    @stats[:finals][:right] += 1 if game_summary[:final_status] == 3
  end
end
