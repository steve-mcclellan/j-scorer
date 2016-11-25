module TopicsQueries
  # rubocop:disable MethodLength

  # For future testing: does one of these work noticeably faster?

  # def topic_sixths_query(user)
  #   raise ArgumentError unless user.is_a? User
  #   "
  #   SELECT t.name AS topic, s.result1, s.result2, s.result3, s.result4,
  #     s.result5, s.type AS sixth_type
  #   FROM topics t
  #   INNER JOIN category_topics c
  #     ON t.id = c.topic_id
  #   INNER JOIN sixths s
  #     ON c.category_id = s.id AND c.category_type = 'Sixth'
  #   INNER JOIN games g
  #     ON s.game_id = g.id
  #   INNER JOIN users u
  #     ON t.user_id = u.id
  #   WHERE t.user_id = #{user.id} AND g.play_type = ANY (u.play_types)
  #   ORDER BY t.name ASC
  #   "
  # end

  # def topic_finals_query(user)
  #   raise ArgumentError unless user.is_a? User
  #   "
  #   SELECT t.name AS topic, f.result AS final_result
  #   FROM topics t
  #   INNER JOIN category_topics c
  #     ON t.id = c.topic_id
  #   INNER JOIN finals f
  #     ON c.category_id = f.id AND c.category_type = 'Final'
  #   INNER JOIN games g
  #     ON f.game_id = g.id
  #   INNER JOIN users u
  #     ON t.user_id = u.id
  #   WHERE t.user_id = #{user.id} AND g.play_type = ANY (u.play_types)
  #   ORDER BY t.name ASC
  #   "
  # end

  def topics_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && play_types.is_a?(Array)
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
