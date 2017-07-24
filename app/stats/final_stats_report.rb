class FinalStatsReport
  # include FinalQueries, FinalAdviceNumbers, SharedStatsMethods
  include FinalQueries, SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    raw_data = ActiveRecord::Base.connection
                                 .select_all(final_query(user, play_types))
                                 .to_hash[0]

    # prepare_hash(finals)
    # crunch_numbers(finals)
    @stats = format_data(raw_data)
  end

  private

  # rubocop:disable MethodLength, AbcSize
  def format_data(d)
    { user: make_stat_array(d, 'user'),
      contestants: [make_stat_array(d, 'contestants'),
                    make_stat_array(d, 'first'),
                    make_stat_array(d, 'second'),
                    make_stat_array(d, 'third')],
      by_get_rate: [[make_stat_array(d, 'zero_for_zero'),
                     make_stat_array(d, 'zero_for_one'),
                     make_stat_array(d, 'zero_for_two'),
                     make_stat_array(d, 'zero_for_three')],
                    [nil,
                     make_stat_array(d, 'one_for_one'),
                     make_stat_array(d, 'one_for_two'),
                     make_stat_array(d, 'one_for_three')],
                    [nil, nil,
                     make_stat_array(d, 'two_for_two'),
                     make_stat_array(d, 'two_for_three')],
                    [nil, nil, nil,
                     make_stat_array(d, 'three_for_three')]],
      when_right: [nil,
                   make_stat_array(d, 'when_first_right'),
                   make_stat_array(d, 'when_second_right'),
                   make_stat_array(d, 'when_third_right')],
      when_wrong: [nil,
                   make_stat_array(d, 'when_first_wrong'),
                   make_stat_array(d, 'when_second_wrong'),
                   make_stat_array(d, 'when_third_wrong')],
      advice: make_advice_hash(d) }
  end
  # rubocop:enable MethodLength, AbcSize

  def make_stat_array(data, attr)
    num = data[attr + '_num'] || 0
    den = data[attr + '_den'] || 0
    [num, den, quotient(num, den)]
  end

  def make_advice_hash(d)
    advice = {}
    %w(
      crush_3p_win crush_2p_win second_third_wrong player_right_first_wrong
      first_third_wrong player_right_first_second_wrong first_second_wrong
    ).each do |situation|
      advice[situation.to_sym] = make_stat_array(d, situation)
    end
    advice
  end

  # def prepare_hash(finals)
  #   finals.map! do |final|
  #     { user_right: final['result'].to_i == 3,
  #       contestants_right: [final['first_right'],
  #                           final['second_right'],
  #                           final['third_right']] }
  #   end
  # end

  # def crunch_numbers(finals)
  #   @stats = { user: [0, 0], contestants: [nil, [0, 0], [0, 0], [0, 0]],
  #              by_get_rate: [[[0, 0], [0, 0], [0, 0], [0, 0]],
  #                            [nil,    [0, 0], [0, 0], [0, 0]],
  #                            [nil,    nil,    [0, 0], [0, 0]],
  #                            [nil,    nil,    nil,    [0, 0]]],
  #              when_right: [nil, [0, 0], [0, 0], [0, 0]],
  #              when_wrong: [nil, [0, 0], [0, 0], [0, 0]] }

  #   initialize_advice_numbers

  #   process_finals(finals)
  #   post_processing
  # end

  # def process_finals(finals)
  #   finals.each do |final|
  #     add_raw_results(final)
  #     add_by_get_rate(final)
  #     add_by_contestant_result(final)
  #     add_advice_numbers(final)
  #   end
  # end

  # def add_raw_results(final)
  #   add_final_to(@stats[:user], final)
  #   (1..3).each { |i| add_final_to(@stats[:contestants][i], final, i) }
  # end

  # def add_by_get_rate(final)
  #   correct_responders = 0
  #   participants = 0

  #   final[:contestants_right].each do |result|
  #     correct_responders += 1 if result
  #     participants += 1 unless result.nil?
  #   end

  #   add_final_to(@stats[:by_get_rate][correct_responders][participants], final)
  # end

  # def add_by_contestant_result(final)
  #   (1..3).each do |i|
  #     case final[:contestants_right][i - 1]
  #     when true then add_final_to(@stats[:when_right][i], final)
  #     when false then add_final_to(@stats[:when_wrong][i], final)
  #     end
  #   end
  # end

  # def add_final_to(arr, final, player = nil)
  #   result = player ? final[:contestants_right][player - 1] : final[:user_right]

  #   case result
  #   when true then arr[0] += 1
  #   when false then arr[1] += 1
  #   end
  # end

  # def post_processing
  #   # Add the contestants' overall stats.
  #   sc = @stats[:contestants]
  #   sc[0] = sc[1..3].transpose.map { |arr| arr.reduce(:+) }

  #   add_averages

  #   @stats[:advice] = @advice
  # end

  # def add_averages
  #   # Assemble the arrays that contain get rates.
  #   arrs = assemble_arrays

  #   # Change the format of each array from [right, wrong] to [right, total]
  #   # and tack on the get rate as a float between 0 and 1.
  #   arrs.each do |arr|
  #     arr[1] += arr[0]
  #     arr << quotient(arr[0], arr[1])
  #   end
  # end

  # def assemble_arrays
  #   ([@stats[:user]] +
  #    @stats[:contestants] +
  #    @stats[:by_get_rate].flatten(1) +
  #    @stats[:when_right] +
  #    @stats[:when_wrong] +
  #    @advice.values).compact
  # end
end
