class RestoreFromBackupJob < ApplicationJob
  include ActiveJob::Status

  def perform(user, games)
    progress.total = games.count
    games.each do |game|
      user.games.create!(parameterize_game(game))
      progress.increment
    end
  end

  private

  def parameterize_game(game)
    { show_date: game[:show_date],
      date_played: game[:date_played],
      play_type: game[:play_type],
      rerun: game[:rerun],
      round_one_score: game[:round_one_score],
      round_two_score: game[:round_two_score],
      final_result: game[:final_result],
      sixths_attributes: parameterize_sixths(game[:sixths_attributes]),
      final_attributes: parameterize_final(game[:final_attributes]) }
  end

  def parameterize_sixths(sixths)
    result = []
    sixths.each do |sixth|
      result.append({ type: sixth[:type],
                      board_position: sixth[:board_position],
                      title: sixth[:title],
                      topics_string: sixth[:topics_string],
                      result1: sixth[:result1],
                      result2: sixth[:result2],
                      result3: sixth[:result3],
                      result4: sixth[:result4],
                      result5: sixth[:result5] })
    end
    result
  end

  def parameterize_final(final)
    { category_title: final[:category_title],
      topics_string: final[:topics_string],
      result: final[:result],
      first_right: final[:first_right],
      second_right: final[:second_right],
      third_right: final[:third_right] }
  end
end
