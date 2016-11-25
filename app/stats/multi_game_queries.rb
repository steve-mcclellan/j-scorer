module MultiGameQueries
  def sixths_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && play_types.is_a?(Array)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')

    "
    SELECT s.type, s.result1, s.result2, s.result3, s.result4, s.result5
    FROM sixths s
    INNER JOIN games g ON g.id = s.game_id
    WHERE g.user_id = #{user.id} AND g.play_type IN (#{play_types_list})
    "
  end

  def count_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && play_types.is_a?(Array)
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
