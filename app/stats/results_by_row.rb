class ResultsByRow
  attr_reader :stats

  # rubocop:disable MethodLength
  def initialize(user)
    @user = user
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

    user.sixths.each { |cat| add_category_to_stats(cat) }
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
end
