class FinalStatsReport
  include FinalQueries, SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    finals = ActiveRecord::Base.connection
                               .select_all(final_query(user, play_types))
                               .to_hash

    prepare_hash(finals)
    crunch_numbers(finals)
  end

  private

  def crunch_numbers(finals)
    @stats = { user: [0, 0], contestants: [nil, [0, 0], [0, 0], [0, 0]],
               by_get_rate: [[[0, 0], [0, 0], [0, 0], [0, 0]],
                             [nil,    [0, 0], [0, 0], [0, 0]],
                             [nil,    nil,    [0, 0], [0, 0]],
                             [nil,    nil,    nil,    [0, 0]]],
               when_right: [nil, [0, 0], [0, 0], [0, 0]],
               when_wrong: [nil, [0, 0], [0, 0], [0, 0]] }

    process_finals(finals)
    post_processing
  end

  def process_finals(finals)
    finals.each do |final|
      add_raw_results(final)
      add_by_get_rate(final)
      add_by_contestant_result(final)
    end
  end

  def add_by_contestant_result(final)
    (1..3).each do |i|
      case final[:contestants_right][i - 1]
      when true then add_final_to(@stats[:when_right][i], final)
      when false then add_final_to(@stats[:when_wrong][i], final)
      end
    end
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

  def add_raw_results(final)
    add_final_to(@stats[:user], final)
    (1..3).each { |i| add_final_to(@stats[:contestants][i], final, i) }
  end

  def prepare_hash(finals)
    finals.map! do |final|
      { user_right: final['result'] == '3',
        contestants_right: [booleanize(final['first_right']),
                            booleanize(final['second_right']),
                            booleanize(final['third_right'])] }
    end
  end

  # rubocop:disable AbcSize
  def post_processing
    sc = @stats[:contestants]
    sc[0] = sc[1..3].transpose.map { |arr| arr.reduce(:+) }

    arrs = [@stats[:user]] + @stats[:contestants] + @stats[:by_get_rate][0] +
           @stats[:by_get_rate][1][1..3] + @stats[:by_get_rate][2][2..3] +
           [@stats[:by_get_rate][3][3]] + @stats[:when_right][1..3] +
           @stats[:when_wrong][1..3]

    arrs.each do |arr|
      arr[1] += arr[0]
      arr << quotient(arr[0], arr[1])
    end
  end
  # rubocop:enable AbcSize

  def booleanize(data)
    case data
    when 't' then true
    when 'f' then false
    end
  end

  def add_final_to(arr, final, player = nil)
    result = player ? final[:contestants_right][player - 1] : final[:user_right]

    case result
    when true then arr[0] += 1
    when false then arr[1] += 1
    end
  end
end
