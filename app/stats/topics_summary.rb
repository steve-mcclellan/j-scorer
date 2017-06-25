# rubocop:disable ClassLength
class TopicsSummary
  include SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    @stats = ActiveRecord::Base.connection
                               .select_all(topics_query(user, play_types))
                               .to_hash

    # crunch_numbers(data)
  end

  private

  # rubocop:disable MethodLength
  def topics_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')
    "
    SELECT
      q.topic_name,
      COUNT(*) FILTER (WHERE q.sixth_type IS NOT NULL) AS sixths_count,
      SUM(q.right) AS right,
      SUM(q.wrong) AS wrong,
      SUM(q.pass) AS pass,
      SUM(q.score) AS score,
      SUM(q.possible_score) AS possible_score,
      (
        CASE
          WHEN SUM(q.possible_score) > 0
            THEN (1.0 * SUM(q.score) / SUM(q.possible_score))
        END
      ) AS efficiency,
      SUM(q.dd_right) + SUM(q.dd_wrong) AS dds,
      SUM(q.dd_right) AS dd_right,
      SUM(q.dd_wrong) AS dd_wrong,
      SUM(q.finals_right) + SUM(q.finals_wrong) AS finals_count,
      SUM(q.finals_right) AS finals_right,
      SUM(q.finals_wrong) AS finals_wrong
    FROM (
      SELECT
        i.topic_name,
        i.sixth_type,
        (
          (CASE WHEN i.result1 = 3 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 = 3 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result3 = 3 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result4 = 3 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result5 = 3 THEN 1 ELSE 0 END)
        ) AS right,
        (
          (CASE WHEN i.result1 = 1 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 = 1 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result3 = 1 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result4 = 1 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result5 = 1 THEN 1 ELSE 0 END)
        ) AS wrong,
        (
          (CASE WHEN i.result1 = 2 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 = 2 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result3 = 2 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result4 = 2 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result5 = 2 THEN 1 ELSE 0 END)
        ) AS pass,
        (
          (CASE WHEN i.result1 IN (3, 7) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 IN (3, 7) THEN 2 ELSE 0 END) +
          (CASE WHEN i.result3 IN (3, 7) THEN 3 ELSE 0 END) +
          (CASE WHEN i.result4 IN (3, 7) THEN 4 ELSE 0 END) +
          (CASE WHEN i.result5 IN (3, 7) THEN 5 ELSE 0 END) +
          (CASE WHEN i.result1 = 1 THEN -1 ELSE 0 END) +
          (CASE WHEN i.result2 = 1 THEN -2 ELSE 0 END) +
          (CASE WHEN i.result3 = 1 THEN -3 ELSE 0 END) +
          (CASE WHEN i.result4 = 1 THEN -4 ELSE 0 END) +
          (CASE WHEN i.result5 = 1 THEN -5 ELSE 0 END)
        ) * i.top_row_value AS score,
        (
          (CASE WHEN i.result1 IN (1, 2, 3, 5, 6, 7) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 IN (1, 2, 3, 5, 6, 7) THEN 2 ELSE 0 END) +
          (CASE WHEN i.result3 IN (1, 2, 3, 5, 6, 7) THEN 3 ELSE 0 END) +
          (CASE WHEN i.result4 IN (1, 2, 3, 5, 6, 7) THEN 4 ELSE 0 END) +
          (CASE WHEN i.result5 IN (1, 2, 3, 5, 6, 7) THEN 5 ELSE 0 END)
        ) * i.top_row_value AS possible_score,
        (
          (CASE WHEN i.result1 = 7 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 = 7 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result3 = 7 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result4 = 7 THEN 1 ELSE 0 END) +
          (CASE WHEN i.result5 = 7 THEN 1 ELSE 0 END)
        ) AS dd_right,
        (
          (CASE WHEN i.result1 IN (5, 6) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result2 IN (5, 6) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result3 IN (5, 6) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result4 IN (5, 6) THEN 1 ELSE 0 END) +
          (CASE WHEN i.result5 IN (5, 6) THEN 1 ELSE 0 END)
        ) AS dd_wrong,
        CASE WHEN i.final_result = 3 THEN 1 ELSE 0 END AS finals_right,
        CASE WHEN i.final_result = 1 THEN 1 ELSE 0 END AS finals_wrong
      FROM (
        SELECT
          t.name AS topic_name,
          s.result1,
          s.result2,
          s.result3,
          s.result4,
          s.result5,
          s.type AS sixth_type,
          (
            CASE s.type
              WHEN 'RoundOneCategory' THEN #{CURRENT_TOP_ROW_VALUES[0]}
              WHEN 'RoundTwoCategory' THEN #{CURRENT_TOP_ROW_VALUES[1]}
            END
          ) AS top_row_value,
          f.result AS final_result
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
          t.user_id = #{user.id}
          AND COALESCE(gOne.play_type, gTwo.play_type) IN (#{play_types_list})
      ) i
    ) q
    GROUP BY topic_name
    ORDER BY topic_name
    "
  end
  # rubocop:enable MethodLength


  # def crunch_numbers(data)
  #   @stats = Hash.new { |hash, key| hash[key] = Hash.new(0) }

  #   data.each do |cat_hash|
  #     if cat_hash['sixth_type']
  #       add_sixth_to_stats(cat_hash)
  #     else
  #       add_final_to_stats(cat_hash)
  #     end
  #   end

  #   add_calculated_stats
  # end

  # def add_sixth_to_stats(cat_hash)
  #   topic_stats = @stats[cat_hash['topic']]
  #   topic_stats[:sixths_count] += 1

  #   trv = top_row_value(cat_hash)
  #   1.upto(5) do |row|
  #     add_clue_to_stats(topic_stats, cat_hash['result' + row.to_s], trv * row)
  #   end
  # end

  # def add_final_to_stats(final_hash)
  #   topic_stats = @stats[final_hash['topic']]
  #   topic_stats[:finals_count] += 1

  #   case final_hash['final_result'].to_i
  #   when 1 then topic_stats[:finals_wrong] += 1
  #   when 3 then topic_stats[:finals_right] += 1
  #   end
  # end

  # def add_calculated_stats
  #   @stats.each_value do |topic_hash|
  #     topic_hash[:efficiency] = quotient(topic_hash[:score],
  #                                        topic_hash[:possible_score])

  #     topic_hash[:dds] = topic_hash[:dd_right] + topic_hash[:dd_wrong]
  #   end
  # end

  # def top_row_value(sixth_hash)
  #   if sixth_hash['sixth_type'] == 'RoundOneCategory'
  #     CURRENT_TOP_ROW_VALUES[0]
  #   else
  #     CURRENT_TOP_ROW_VALUES[1]
  #   end
  # end
end
# rubocop:enable ClassLength
