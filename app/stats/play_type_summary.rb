class PlayTypeSummary
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
      ORDER BY games_count DESC, play_type DESC
    "

    @stats = ActiveRecord::Base.connection.select_all(query).to_hash
  end
  # rubocop:enable MethodLength
end
