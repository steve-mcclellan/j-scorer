# These queries use the valid_types? method from the SharedStatsMethods module.
module MultiGameQueries
  # rubocop:disable MethodLength
  def sixths_query(user, play_types)
    validate_query_inputs(user, play_types)
    play_types_list = format_play_types_for_sql(play_types)

    "
    SELECT
      (
        CASE c.type
          WHEN 'RoundOneCategory' THEN 1
          WHEN 'RoundTwoCategory' THEN 2
        END
      ) AS round_number,
      #{count_results('c', 3)} AS right,
      #{count_results('c', 1)} AS wrong,
      #{count_results('c', 2)} AS pass,
      #{count_results('c', 7)} AS dd_right,
      #{count_results('c', [5, 6])} AS dd_wrong,
      (
        (#{count_results('c', [3, 7], true)}) -
        (#{count_results('c', 1, true)})
      ) AS raw_score,
      #{count_results('c', [1, 2, 3, 5, 6, 7], true)} AS raw_possible_score
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
    validate_query_inputs(user, play_types)
    play_types_list = format_play_types_for_sql(play_types)

    "
    SELECT COUNT(*) AS games,
           COUNT(*) FILTER (WHERE f.result = 3) AS finals_right,
           COUNT(*) FILTER (WHERE f.result = 1) AS finals_wrong
    FROM games g
    LEFT JOIN finals f ON g.id = f.game_id
    WHERE g.user_id = #{user.id} AND g.play_type IN (#{play_types_list})
    "
  end

  private

  def count_results(table, value, weight = false)
    condition = value.is_a?(Array) ? "IN (#{value.join(', ')})" : "= #{value}"
    "
    #{'1 * ' if weight}COUNT(*) FILTER (WHERE #{table}.result1 #{condition}) +
    #{'2 * ' if weight}COUNT(*) FILTER (WHERE #{table}.result2 #{condition}) +
    #{'3 * ' if weight}COUNT(*) FILTER (WHERE #{table}.result3 #{condition}) +
    #{'4 * ' if weight}COUNT(*) FILTER (WHERE #{table}.result4 #{condition}) +
    #{'5 * ' if weight}COUNT(*) FILTER (WHERE #{table}.result5 #{condition})
    "
  end
end
