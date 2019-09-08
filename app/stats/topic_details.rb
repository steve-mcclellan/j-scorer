class TopicDetails
  include SharedStatsMethods

  attr_reader :stats

  def initialize(topic, play_types, filters)
    query = topic_details_query(topic, play_types, coalesce_filters(filters))
    raw_stats = ActiveRecord::Base.connection.select_all(query).to_a

    @stats = { RoundOneCategory: [], RoundTwoCategory: [], Final: [] }
    raw_stats.each { |cat| @stats[cat['cat_type'].to_sym].push(cat) }
  end

  # rubocop:disable MethodLength
  def topic_details_query(topic, play_types, other_filters)
    validate_query_inputs(topic.user, play_types)
    play_types_list = format_play_types_for_sql(play_types)
    "
    SELECT
      *,
      #{result_count('i', 3)} AS right,
      #{result_count('i', 1)} AS wrong,
      #{result_count('i', 2)} AS pass,
      (
        (#{result_count('i', [3, 7], true)}) -
        (#{result_count('i', 1, true)})
      ) * i.top_row_value AS score,
      (
        #{result_count('i', [1, 2, 3, 5, 6, 7], true)}
      ) * i.top_row_value AS possible_score,
      #{result_count('i', 7)} AS dd_right,
      #{result_count('i', [5, 6])} AS dd_wrong,
      CASE WHEN i.final_result = 3 THEN 1 ELSE 0 END AS final_right,
      CASE WHEN i.final_result = 1 THEN 1 ELSE 0 END AS final_wrong
    FROM (
      SELECT
        COALESCE(gOne.show_date, gTwo.show_date) AS show_date,
        COALESCE(gOne.game_id, gTwo.game_id) AS game_id,
        COALESCE(gOne.date_played, gTwo.date_played) AS date_played,
        s.board_position,
        s.result1,
        s.result2,
        s.result3,
        s.result4,
        s.result5,
        COALESCE(s.type, 'Final') AS cat_type,
        (
          CASE s.type
            WHEN 'RoundOneCategory' THEN #{CURRENT_TOP_ROW_VALUES[0]}
            WHEN 'RoundTwoCategory' THEN #{CURRENT_TOP_ROW_VALUES[1]}
          END
        ) AS top_row_value,
        f.result AS final_result,
        (
          CASE WHEN f.first_right THEN 1 ELSE 0 END +
          CASE WHEN f.second_right THEN 1 ELSE 0 END +
          CASE WHEN f.third_right THEN 1 ELSE 0 END
        ) AS final_onair_right,
        (
          CASE WHEN f.first_right IS FALSE THEN 1 ELSE 0 END +
          CASE WHEN f.second_right IS FALSE THEN 1 ELSE 0 END +
          CASE WHEN f.third_right IS FALSE THEN 1 ELSE 0 END
        ) AS final_onair_wrong
      FROM
        topics t
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
      WHERE
        t.id = #{topic.id}
        AND COALESCE(gOne.play_type, gTwo.play_type) IN (#{play_types_list})
        #{other_filters}
    ) i
    "
  end
  # rubocop:enable MethodLength
end