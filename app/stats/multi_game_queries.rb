# These queries use the valid_types? method from the SharedStatsMethods module.
module MultiGameQueries
  # rubocop:disable MethodLength
  def sixths_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')

    "
    SELECT
      (
        CASE c.type
          WHEN 'RoundOneCategory' THEN 1
          WHEN 'RoundTwoCategory' THEN 2
        END
      ) AS round_number,
      (
        COUNT(*) FILTER (WHERE c.result1 = 3) +
        COUNT(*) FILTER (WHERE c.result2 = 3) +
        COUNT(*) FILTER (WHERE c.result3 = 3) +
        COUNT(*) FILTER (WHERE c.result4 = 3) +
        COUNT(*) FILTER (WHERE c.result5 = 3)
      ) AS right,
      (
        COUNT(*) FILTER (WHERE c.result1 = 1) +
        COUNT(*) FILTER (WHERE c.result2 = 1) +
        COUNT(*) FILTER (WHERE c.result3 = 1) +
        COUNT(*) FILTER (WHERE c.result4 = 1) +
        COUNT(*) FILTER (WHERE c.result5 = 1)
      ) AS wrong,
      (
        COUNT(*) FILTER (WHERE c.result1 = 2) +
        COUNT(*) FILTER (WHERE c.result2 = 2) +
        COUNT(*) FILTER (WHERE c.result3 = 2) +
        COUNT(*) FILTER (WHERE c.result4 = 2) +
        COUNT(*) FILTER (WHERE c.result5 = 2)
      ) AS pass,
      (
        COUNT(*) FILTER (WHERE c.result1 = 7) +
        COUNT(*) FILTER (WHERE c.result2 = 7) +
        COUNT(*) FILTER (WHERE c.result3 = 7) +
        COUNT(*) FILTER (WHERE c.result4 = 7) +
        COUNT(*) FILTER (WHERE c.result5 = 7)
      ) AS dd_right,
      (
        COUNT(*) FILTER (WHERE c.result1 IN (5, 6)) +
        COUNT(*) FILTER (WHERE c.result2 IN (5, 6)) +
        COUNT(*) FILTER (WHERE c.result3 IN (5, 6)) +
        COUNT(*) FILTER (WHERE c.result4 IN (5, 6)) +
        COUNT(*) FILTER (WHERE c.result5 IN (5, 6))
      ) AS dd_wrong,
      (
        (1 * COUNT(*) FILTER (WHERE c.result1 IN (3, 7))) +
        (2 * COUNT(*) FILTER (WHERE c.result2 IN (3, 7))) +
        (3 * COUNT(*) FILTER (WHERE c.result3 IN (3, 7))) +
        (4 * COUNT(*) FILTER (WHERE c.result4 IN (3, 7))) +
        (5 * COUNT(*) FILTER (WHERE c.result5 IN (3, 7))) +
        (-1 * COUNT(*) FILTER (WHERE c.result1 = 1)) +
        (-2 * COUNT(*) FILTER (WHERE c.result2 = 1)) +
        (-3 * COUNT(*) FILTER (WHERE c.result3 = 1)) +
        (-4 * COUNT(*) FILTER (WHERE c.result4 = 1)) +
        (-5 * COUNT(*) FILTER (WHERE c.result5 = 1))
      ) AS raw_score,
      (
        (1 * COUNT(*) FILTER (WHERE c.result1 IN (1, 2, 3, 5, 6, 7))) +
        (2 * COUNT(*) FILTER (WHERE c.result2 IN (1, 2, 3, 5, 6, 7))) +
        (3 * COUNT(*) FILTER (WHERE c.result3 IN (1, 2, 3, 5, 6, 7))) +
        (4 * COUNT(*) FILTER (WHERE c.result4 IN (1, 2, 3, 5, 6, 7))) +
        (5 * COUNT(*) FILTER (WHERE c.result5 IN (1, 2, 3, 5, 6, 7)))
      ) AS raw_possible_score
    FROM (
      SELECT s.type, s.result1, s.result2, s.result3, s.result4, s.result5
      FROM
        sixths s
        INNER JOIN games g ON g.id = s.game_id
      WHERE g.user_id = #{user.id} AND g.play_type IN (#{play_types_list})
    ) c
    GROUP BY type
    "
  end
  # rubocop:enable MethodLength

  def finals_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')

    "
    SELECT COUNT(*) AS games,
           COUNT(*) FILTER (WHERE f.result = 3) AS finals_right,
           COUNT(*) FILTER (WHERE f.result = 1) AS finals_wrong
    FROM games g
    LEFT JOIN finals f ON g.id = f.game_id
    WHERE g.user_id = #{user.id} AND g.play_type IN (#{play_types_list})
    "
  end
end
