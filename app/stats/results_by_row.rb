class ResultsByRow
  include SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    # @stats = { round_one:
    #            [0,
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 }],
    #            round_two:
    #            [0,
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
    #             { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 }] }

    # cats = user.sixths.joins(:game).where(games: { play_type: play_types })
    # cats.each { |cat| add_category_to_stats(cat) }

    # add_efficiencies
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

  # def add_category_to_stats(cat)
  #   round = cat.is_a?(RoundOneCategory) ? :round_one : :round_two

  #   1.upto(5) do |row|
  #     add_clue_to_stats(cat.send('result' + row.to_s), @stats[round][row])
  #   end
  # end

  # def add_clue_to_stats(result_code, row_stats)
  #   case result_code
  #   when 1 then row_stats[:wrong] += 1
  #   when 2 then row_stats[:pass] += 1
  #   when 3 then row_stats[:right] += 1
  #   when 5..6 then row_stats[:dd_wrong] += 1
  #   when 7 then row_stats[:dd_right] += 1
  #   end
  # end

  # def add_efficiencies
  #   [:round_one, :round_two].each do |round|
  #     1.upto(5) do |row_number|
  #       row = @stats[round][row_number]
  #       row[:eff_num] = row[:right] - row[:wrong]
  #       row[:eff_den] = row[:right] + row[:wrong] + row[:pass]
  #       row[:efficiency] = calculate_efficiency(row)
  #       row[:dd_eff] = calculate_dd_efficiency(row)

  #       assign_colors(row)
  #     end
  #   end
  # end

  # def calculate_efficiency(row)
  #   return nil if row[:eff_den].zero?
  #   row[:eff_num].fdiv(row[:eff_den])
  # end

  # def calculate_dd_efficiency(row)
  #   return nil if row[:dd_right].zero? && row[:dd_wrong].zero?
  #   row[:dd_right].fdiv(row[:dd_right] + row[:dd_wrong])
  # end

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
