# This module relies on methods from the SharedStatsMethods module.
# rubocop:disable ModuleLength
module FinalQueries
  # rubocop:disable MethodLength
  def final_query(user, play_types, other_filters)
    validate_query_inputs(user, play_types)
    play_types_list = format_play_types_for_sql(play_types)

    "
    SELECT
      COUNT(*) FILTER (WHERE result = 3) AS user_num,
      COUNT(*) AS user_den,
      SUM(contestants_right) AS contestants_num,
      SUM(contestants_right) + SUM(contestants_wrong) AS contestants_den,
      COUNT(*) FILTER (WHERE first_right) AS first_num,
      COUNT(*) FILTER (WHERE first_right IS NOT NULL) AS first_den,
      COUNT(*) FILTER (WHERE second_right) AS second_num,
      COUNT(*) FILTER (WHERE second_right IS NOT NULL) AS second_den,
      COUNT(*) FILTER (WHERE third_right) AS third_num,
      COUNT(*) FILTER (WHERE third_right IS NOT NULL) AS third_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_total = 0
      ) AS zero_for_zero_num,
      COUNT(*) FILTER (WHERE contestants_total = 0) AS zero_for_zero_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 0 AND contestants_total = 1
      ) AS zero_for_one_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 0 AND contestants_total = 1
      ) AS zero_for_one_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 0 AND contestants_total = 2
      ) AS zero_for_two_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 0 AND contestants_total = 2
      ) AS zero_for_two_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 0 AND contestants_total = 3
      ) AS zero_for_three_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 0 AND contestants_total = 3
      ) AS zero_for_three_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 1 AND contestants_total = 1
      ) AS one_for_one_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 1 AND contestants_total = 1
      ) AS one_for_one_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 1 AND contestants_total = 2
      ) AS one_for_two_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 1 AND contestants_total = 2
      ) AS one_for_two_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 1 AND contestants_total = 3
      ) AS one_for_three_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 1 AND contestants_total = 3
      ) AS one_for_three_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 2 AND contestants_total = 2
      ) AS two_for_two_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 2 AND contestants_total = 2
      ) AS two_for_two_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 2 AND contestants_total = 3
      ) AS two_for_three_num,
      COUNT(*) FILTER (
        WHERE contestants_right = 2 AND contestants_total = 3
      ) AS two_for_three_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND contestants_right = 3
      ) AS three_for_three_num,
      COUNT(*) FILTER (WHERE contestants_right = 3) AS three_for_three_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND first_right
      ) AS when_first_right_num,
      COUNT(*) FILTER (WHERE first_right) AS when_first_right_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND second_right
      ) AS when_second_right_num,
      COUNT(*) FILTER (WHERE second_right) AS when_second_right_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND third_right
      ) AS when_third_right_num,
      COUNT(*) FILTER (WHERE third_right) AS when_third_right_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND first_right IS FALSE
      ) AS when_first_wrong_num,
      COUNT(*) FILTER (WHERE first_right IS FALSE) AS when_first_wrong_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND second_right IS FALSE
      ) AS when_second_wrong_num,
      COUNT(*) FILTER (WHERE second_right IS FALSE) AS when_second_wrong_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND third_right IS FALSE
      ) AS when_third_wrong_num,
      COUNT(*) FILTER (WHERE third_right IS FALSE) AS when_third_wrong_den,
      COUNT(*) FILTER (
        WHERE (
          (result = 3 OR (second_right IS FALSE AND third_right IS FALSE))
          AND second_right IS NOT NULL AND third_right IS NOT NULL
        )
      ) AS crush_3p_win_num,
      COUNT(*) FILTER (
        WHERE second_right IS NOT NULL AND third_right IS NOT NULL
      ) AS crush_3p_win_den,
      COUNT(*) FILTER (
        WHERE (result = 3 OR second_right IS FALSE) AND second_right IS NOT NULL
      ) AS crush_2p_win_num,
      COUNT(*) FILTER (
        WHERE second_right IS NOT NULL
      ) AS crush_2p_win_den,
      COUNT(*) FILTER (
        WHERE second_right IS FALSE AND third_right IS FALSE
      ) AS second_third_wrong_num,
      COUNT(*) FILTER (
        WHERE second_right IS NOT NULL AND third_right IS NOT NULL
      ) AS second_third_wrong_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND first_right IS FALSE
      ) AS player_right_first_wrong_num,
      COUNT(*) FILTER (
        WHERE first_right IS NOT NULL
      ) AS player_right_first_wrong_den,
      COUNT(*) FILTER (
        WHERE first_right IS FALSE AND third_right IS FALSE
      ) AS first_third_wrong_num,
      COUNT(*) FILTER (
        WHERE first_right IS NOT NULL AND third_right IS NOT NULL
      ) AS first_third_wrong_den,
      COUNT(*) FILTER (
        WHERE result = 3 AND first_right IS FALSE and second_right IS FALSE
      ) AS player_right_first_second_wrong_num,
      COUNT(*) FILTER (
        WHERE first_right IS NOT NULL AND second_right IS NOT NULL
      ) AS player_right_first_second_wrong_den,
      COUNT(*) FILTER (
        WHERE first_right IS FALSE and second_right IS FALSE
      ) AS first_second_wrong_num,
      COUNT(*) FILTER (
        WHERE first_right IS NOT NULL AND second_right IS NOT NULL
      ) AS first_second_wrong_den
    FROM (
      SELECT
        f.result,
        f.first_right,
        f.second_right,
        f.third_right,
        (
          CASE WHEN f.first_right THEN 1 ELSE 0 END +
          CASE WHEN f.second_right THEN 1 ELSE 0 END +
          CASE WHEN f.third_right THEN 1 ELSE 0 END
        ) AS contestants_right,
        (
          CASE WHEN f.first_right IS FALSE THEN 1 ELSE 0 END +
          CASE WHEN f.second_right IS FALSE THEN 1 ELSE 0 END +
          CASE WHEN f.third_right IS FALSE THEN 1 ELSE 0 END
        ) AS contestants_wrong,
        (
          CASE WHEN f.first_right IS NOT NULL THEN 1 ELSE 0 END +
          CASE WHEN f.second_right IS NOT NULL THEN 1 ELSE 0 END +
          CASE WHEN f.third_right IS NOT NULL THEN 1 ELSE 0 END
        ) AS contestants_total
      FROM finals f
      INNER JOIN games g ON g.id = f.game_id
      WHERE
        g.user_id = #{user.id}
        AND g.play_type IN (#{play_types_list})
        #{other_filters}
        AND f.result IN (1, 3)
    ) q
    "
  end
  # rubocop:enable MethodLength
end
# rubocop:enable ModuleLength
