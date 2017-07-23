class PlayTypeSummary
  # include SharedStatsMethods

  attr_reader :stats

  # rubocop:disable MethodLength
  def initialize(user)
    raise ArgumentError unless user.is_a?(User)

    query = "
      SELECT
        q.play_type,
        COUNT(*) AS games_count,
        AVG(q.game_score) AS average_score,
        MAX(q.game_score) AS max,
        MIN(q.game_score) AS min,
        (
          CASE
            WHEN (COUNT(*) FILTER (WHERE q.final_result IN (1, 3)) > 0)
              THEN (
                1.0 * (COUNT(*) FILTER (WHERE q.final_result = 3)) /
                      (COUNT(*) FILTER (WHERE q.final_result IN (1, 3)))
              )
          END
        ) AS final_rate
      FROM (
        SELECT g.play_type,
          (g.round_one_score * #{CURRENT_TOP_ROW_VALUES[0]}) +
          (g.round_two_score * #{CURRENT_TOP_ROW_VALUES[1]}) AS game_score,
          f.result AS final_result
        FROM games g
        LEFT JOIN finals f ON f.game_id = g.id
        WHERE user_id = #{user.id}
        ORDER BY play_type ASC
      ) q
      GROUP BY play_type
      ORDER BY games_count DESC
    "

    @stats = ActiveRecord::Base.connection.select_all(query).to_hash
    # data = ActiveRecord::Base.connection.select_all(query).to_hash

    # crunch_numbers(data)
  end
  # rubocop:enable MethodLength

  # private

  # def crunch_numbers(data)
  #   @stats = Hash.new do |hash, key|
  #     hash[key] = { games_count: 0, total_score: 0,
  #                   min: Float::INFINITY, max: -Float::INFINITY,
  #                   finals_right: 0, finals_wrong: 0 }
  #   end

  #   data.each { |game_hash| add_game_to_stats(game_hash) }

  #   add_averages
  # end

  # def add_game_to_stats(game_hash)
  #   type_stats = @stats[game_hash['play_type']]
  #   game_score = game_hash['game_score'].to_i

  #   type_stats[:games_count] += 1
  #   type_stats[:total_score] += game_score
  #   type_stats[:min] = [type_stats[:min], game_score].min
  #   type_stats[:max] = [type_stats[:max], game_score].max
  #   type_stats[:finals_right] += 1 if game_hash['final_result'].to_i == 3
  #   type_stats[:finals_wrong] += 1 if game_hash['final_result'].to_i == 1
  # end

  # def add_averages
  #   @stats.each_value do |type_stats|
  #     type_stats[:average_score] = quotient(type_stats[:total_score],
  #                                           type_stats[:games_count])
  #     type_stats[:final_rate] = quotient(type_stats[:finals_right],
  #                                        type_stats[:finals_right] +
  #                                        type_stats[:finals_wrong])
  #   end
  # end
end
