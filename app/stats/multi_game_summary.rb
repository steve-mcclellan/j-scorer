class MultiGameSummary
  include MultiGameQueries
  include SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types, filters)
    round_info_query = sixths_query(user, play_types, filters)
    round_info = ActiveRecord::Base.connection
                                   .select_all(round_info_query).to_hash

    count_query = finals_query(user, play_types, filters)
    count = ActiveRecord::Base.connection.select_all(count_query).to_hash[0]

    initialize_stats
    reformat_data(round_info)
    add_calculated_stats(count)
  end

  private

  def initialize_stats
    # Most of this will be overwritten, but initialize it anyway to avoid
    # errors if the round_info SQL comes back empty (e.g., for a new user).
    @stats = { round_one: { right: 0, wrong: 0, pass: 0,
                            dd_right: 0, dd_wrong: 0,
                            score: 0, possible_score: 0 },
               round_two: { right: 0, wrong: 0, pass: 0,
                            dd_right: 0, dd_wrong: 0,
                            score: 0, possible_score: 0 },
               finals: { right: 0, wrong: 0 },
               all: {} }
  end

  def reformat_data(round_info)
    round_info.each do |round_hash|
      if round_hash['round_number'] == 1
        @stats[:round_one] = convert_stats(round_hash)
      elsif round_hash['round_number'] == 2
        @stats[:round_two] = convert_stats(round_hash)
      end
    end
  end

  def convert_stats(round_hash)
    top_row_value = CURRENT_TOP_ROW_VALUES[round_hash['round_number'] - 1]
    { right: round_hash['right'],
      wrong: round_hash['wrong'],
      pass: round_hash['pass'],
      dd_right: round_hash['dd_right'],
      dd_wrong: round_hash['dd_wrong'],
      score: round_hash['raw_score'] * top_row_value,
      possible_score: round_hash['raw_possible_score'] * top_row_value }
  end

  def add_calculated_stats(count)
    @stats[:all][:game_count] = count['games'].to_i

    %i[round_one round_two].each do |round|
      @stats[round][:dds] = @stats[round][:dd_right] + @stats[round][:dd_wrong]
    end

    %i[
      right wrong pass dds dd_right dd_wrong score possible_score
    ].each do |stat|
      @stats[:all][stat] = @stats[:round_one][stat] + @stats[:round_two][stat]
    end

    add_final_and_rate_stats(count)
  end

  def add_final_and_rate_stats(count)
    @stats[:finals][:right] = count['finals_right'].to_i
    @stats[:finals][:wrong] = count['finals_wrong'].to_i
    @stats[:finals][:count] = @stats[:finals][:right] + @stats[:finals][:wrong]
    @stats[:finals][:rate] = quotient(@stats[:finals][:right],
                                      @stats[:finals][:count])
    add_rate_stats
  end

  def add_rate_stats
    %i[round_one round_two all].each do |round|
      @stats[round][:average_score] = quotient(@stats[round][:score],
                                               @stats[:all][:game_count])
      @stats[round][:efficiency] = quotient(@stats[round][:score],
                                            @stats[round][:possible_score])
      @stats[round][:dd_rate] = quotient(@stats[round][:dd_right],
                                         @stats[round][:dds])
    end
  end
end
