class ResultsByRow
  include SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    row_results = ActiveRecord::Base.connection
                                    .select_all(by_row_query(user, play_types))
                                    .to_hash

    @stats = { round_one: [0] + row_results[0..4],
               round_two: [0] + row_results[5..9] }

    assign_colors
  end

  private

  def by_row_query(user, play_types)
    validate_query_inputs(user, play_types)
    play_types_list = format_play_types_for_sql(play_types)
    rows = []
    %w(RoundOneCategory RoundTwoCategory).each do |round_type|
      1.upto(5).each do |row_num|
        rows.push(single_row_sql(row_num, round_type, user, play_types_list))
      end
    end
    "( #{rows.join(' ) UNION ALL ( ')} )"
  end

  # rubocop:disable MethodLength
  def single_row_sql(row_num, round_type, user, play_types_list)
    "
    SELECT
      q.right,
      q.wrong,
      q.pass,
      q.right - q.wrong AS eff_num,
      q.right + q.wrong + q.pass AS eff_den,
      CAST (
        CASE
          WHEN q.right + q.wrong + q.pass > 0
            THEN 1.0 * (q.right - q.wrong) / (q.right + q.wrong + q.pass)
        END
      AS float) AS efficiency,
      q.dd_right,
      q.dd_wrong,
      CAST (
        CASE
          WHEN q.dd_right + q.dd_wrong > 0
            THEN 1.0 * q.dd_right / (q.dd_right + q.dd_wrong)
        END
      AS float) AS dd_eff
    FROM (
      SELECT
        COUNT(*) FILTER (WHERE s.result#{row_num} = 3) AS right,
        COUNT(*) FILTER (WHERE s.result#{row_num} = 1) AS wrong,
        COUNT(*) FILTER (WHERE s.result#{row_num} = 2) AS pass,
        COUNT(*) FILTER (WHERE s.result#{row_num} = 7) AS dd_right,
        COUNT(*) FILTER (WHERE s.result#{row_num} IN (5, 6)) AS dd_wrong
      FROM
        sixths s
        INNER JOIN games g ON s.game_id = g.id
      WHERE
        g.user_id = #{user.id}
        AND g.play_type IN (#{play_types_list})
        AND s.type = '#{round_type}'
    ) q
    "
  end
  # rubocop:enable MethodLength

  def assign_colors
    [:round_one, :round_two].each do |round|
      1.upto(5) do |row_number|
        row = @stats[round][row_number]
        row['regular_color'] = to_color_code(row['efficiency'], -1.0, 1.0)
        row['dd_color'] = to_color_code(row['dd_eff'], 0.0, 1.0)
      end
    end
  end

  # Calculates the position of val on a color gradient where min_val is
  # min_color, the mean of min_val and max_val is white, and max_val
  # is max_color. Returns this position as a CSS color code.
  def to_color_code(val, min_val, max_val,
                    min_color = [255, 0, 0], max_color = [0, 255, 0])
    raise ArgumentError unless min_val < max_val
    return 'rgb(127, 127, 127)' if val.nil?

    mid_val = (min_val + max_val).fdiv(2)
    half_gradient_length = mid_val - min_val

    dark_color = val < mid_val ? min_color : max_color

    # How much of the dark color shows through the white
    alpha = (val - mid_val).abs / half_gradient_length

    rgb_values = dark_color.map { |n| (alpha * n + (1 - alpha) * 255).floor }

    "rgb(#{rgb_values.join(', ')})"
  end
end
