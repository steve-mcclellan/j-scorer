class FinalStatsReport
  include FinalQueries, FinalAdviceNumbers, SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    finals = ActiveRecord::Base.connection
                               .select_all(final_query(user, play_types))
                               .to_hash

    prepare_hash(finals)
    crunch_numbers(finals)
  end

  private

  def prepare_hash(finals)
    finals.map! do |final|
      { user_right: final['result'].to_i == 3,
        contestants_right: [final['first_right'],
                            final['second_right'],
                            final['third_right']] }
    end
  end

  def crunch_numbers(finals)
    @stats = { user: [0, 0], contestants: [nil, [0, 0], [0, 0], [0, 0]],
               by_get_rate: [[[0, 0], [0, 0], [0, 0], [0, 0]],
                             [nil,    [0, 0], [0, 0], [0, 0]],
                             [nil,    nil,    [0, 0], [0, 0]],
                             [nil,    nil,    nil,    [0, 0]]],
               when_right: [nil, [0, 0], [0, 0], [0, 0]],
               when_wrong: [nil, [0, 0], [0, 0], [0, 0]] }

    initialize_advice_numbers

    process_finals(finals)
    post_processing
  end

  def process_finals(finals)
    finals.each do |final|
      add_raw_results(final)
      add_by_get_rate(final)
      add_by_contestant_result(final)
      add_advice_numbers(final)
    end
  end

  def add_raw_results(final)
    add_final_to(@stats[:user], final)
    (1..3).each { |i| add_final_to(@stats[:contestants][i], final, i) }
  end

  def add_by_get_rate(final)
    correct_responders = 0
    participants = 0

    final[:contestants_right].each do |result|
      correct_responders += 1 if result
      participants += 1 unless result.nil?
    end

    add_final_to(@stats[:by_get_rate][correct_responders][participants], final)
  end

  def add_by_contestant_result(final)
    (1..3).each do |i|
      case final[:contestants_right][i - 1]
      when true then add_final_to(@stats[:when_right][i], final)
      when false then add_final_to(@stats[:when_wrong][i], final)
      end
    end
  end

  def add_final_to(arr, final, player = nil)
    result = player ? final[:contestants_right][player - 1] : final[:user_right]

    case result
    when true then arr[0] += 1
    when false then arr[1] += 1
    end
  end

  def post_processing
    # Add the contestants' overall stats.
    sc = @stats[:contestants]
    sc[0] = sc[1..3].transpose.map { |arr| arr.reduce(:+) }

    add_averages

    @stats[:advice] = @advice
  end

  def add_averages
    # Assemble the arrays that contain get rates.
    arrs = assemble_arrays

    # Change the format of each array from [right, wrong] to [right, total]
    # and tack on the get rate as a float between 0 and 1.
    arrs.each do |arr|
      arr[1] += arr[0]
      arr << quotient(arr[0], arr[1])
    end
  end

  def assemble_arrays
    ([@stats[:user]] +
     @stats[:contestants] +
     @stats[:by_get_rate].flatten(1) +
     @stats[:when_right] +
     @stats[:when_wrong] +
     @advice.values).compact
  end
end
