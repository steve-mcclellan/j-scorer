# This module relies on valid_types? from the SharedStatsMethods module.
module TopicsQueries
  # rubocop:disable MethodLength
  def topics_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')
    "
    SELECT t.name AS topic, s.result1, s.result2, s.result3, s.result4,
      s.result5, s.type AS sixth_type, f.result AS final_result
    FROM topics t
    INNER JOIN category_topics c
      ON t.id = c.topic_id
    LEFT JOIN sixths s
      ON c.category_id = s.id AND c.category_type = 'Sixth'
    LEFT JOIN finals f
      ON c.category_id = f.id AND c.category_type = 'Final'
    LEFT JOIN games gOne
      ON s.game_id = gOne.id
    LEFT JOIN games gTwo
      ON f.game_id = gTwo.id
    WHERE t.user_id = #{user.id}
      AND COALESCE(gOne.play_type, gTwo.play_type) IN (#{play_types_list})
    "
  end
  # rubocop:enable MethodLength
end
