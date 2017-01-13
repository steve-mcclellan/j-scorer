class ResultsByRow
  attr_reader :stats

  # rubocop:disable MethodLength
  def initialize(user, play_types)
    @stats = { round_one:
               [0,
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 }],
               round_two:
               [0,
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 },
                { right: 0, wrong: 0, pass: 0, dd_right: 0, dd_wrong: 0 }] }

    cats = user.sixths.joins(:game).where(games: { play_type: play_types })
    cats.each { |cat| add_category_to_stats(cat) }

    add_efficiencies
  end
  # rubocop:enable MethodLength

  private

  def add_category_to_stats(cat)
    round = cat.is_a?(RoundOneCategory) ? :round_one : :round_two

    1.upto(5) do |row|
      add_clue_to_stats(cat.send('result' + row.to_s), @stats[round][row])
    end
  end

  def add_clue_to_stats(result_code, row_stats)
    case result_code
    when 1 then row_stats[:wrong] += 1
    when 2 then row_stats[:pass] += 1
    when 3 then row_stats[:right] += 1
    when 5..6 then row_stats[:dd_wrong] += 1
    when 7 then row_stats[:dd_right] += 1
    end
  end

  def add_efficiencies
    [:round_one, :round_two].each do |round|
      1.upto(5) do |row_number|
        row = @stats[round][row_number]
        row[:eff_num] = row[:right] - row[:wrong]
        row[:eff_den] = row[:right] + row[:wrong] + row[:pass]
        row[:efficiency] = calculate_efficiency(row)
        row[:dd_eff] = calculate_dd_efficiency(row)

        assign_colors(row)
      end
    end
  end

  def calculate_efficiency(row)
    return nil if row[:eff_den].zero?
    row[:eff_num].fdiv(row[:eff_den])
  end

  def calculate_dd_efficiency(row)
    return nil if row[:dd_right].zero? && row[:dd_wrong].zero?
    row[:dd_right].fdiv(row[:dd_right] + row[:dd_wrong])
  end

  def assign_colors(row)
    row[:regular_color] = to_color_code(row[:efficiency], -1.0, 1.0)
    row[:dd_color] = to_color_code(row[:dd_eff], 0.0, 1.0)
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
