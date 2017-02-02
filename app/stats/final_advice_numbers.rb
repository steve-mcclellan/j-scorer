module FinalAdviceNumbers
  # Called from final_stats_report.rb as part of initialization.
  def initialize_advice_numbers
    @advice = { crush_3p_win: [0, 0],
                crush_2p_win: [0, 0],
                second_third_wrong: [0, 0],
                player_right_first_wrong: [0, 0],
                first_third_wrong: [0, 0],
                player_right_first_second_wrong: [0, 0],
                first_second_wrong: [0, 0] }
  end

  # Called from final_stats_report.rb for each Final.
  def add_advice_numbers(final)
    # Assemble all results into one array:
    # [player, first, second, third]
    final_results = [final[:user_right]] + final[:contestants_right]

    add_advice_from_first(final_results)
    add_advice_from_second(final_results)
    add_advice_from_third(final_results)
  end

  def add_advice_from_first(final_results)
    add_3_way_crush(final_results)
    add_2_way_crush(final_results)
    add_second_third_miss(final_results)
  end

  def add_advice_from_second(final_results)
    add_player_right_first_miss(final_results)
    add_first_third_miss(final_results)
  end

  def add_advice_from_third(final_results)
    add_player_right_first_second_miss(final_results)
    add_first_second_miss(final_results)
  end

  # Below: all of the numbers from the advice area.

  # 1.1 - From first: chance of a big payday.
  # (Correct rate - easily grabbable from main portion of report.)

  # 1.1a - From first: chance of winning a 3-way crush.
  # (This equals the chance the player is right PLUS the chance
  #  the player, second, and third are all wrong.)
  def add_3_way_crush(results)
    return if results[0].nil? || results[2].nil? || results[3].nil?
    n = results[0] || (!results[2] && !results[3]) ? 0 : 1
    @advice[:crush_3p_win][n] += 1
  end

  # 1.1b - From first: chance of winning a 2-way crush.
  # (This equals the chance the player is right PLUS the chance
  #  the player and second are both wrong.)
  def add_2_way_crush(results)
    return if results[0].nil? || results[2].nil?
    n = results[0] || !results[2] ? 0 : 1
    @advice[:crush_2p_win][n] += 1
  end

  # 1.2a - Chance of second missing.
  # (Easily grabbable from main portion of report.)

  # 1.2b - Chance of third missing.
  # (Easily grabbable from main portion of report.)

  # 1.2c - Chance of second and third both missing.
  def add_second_third_miss(results)
    return if results[2].nil? || results[3].nil?
    n = results[2] || results[3] ? 1 : 0
    @advice[:second_third_wrong][n] += 1
  end

  # 2.1 - From second: chance player is right and leader misses.
  def add_player_right_first_miss(results)
    return if results[0].nil? || results[1].nil?
    n = results[0] && !results[1] ? 0 : 1
    @advice[:player_right_first_wrong][n] += 1
  end

  # 2.2 - From second: chance leader misses.
  # (Easily grabbable from main portion of report.)

  # 2.3 - From second: chance first and third both miss.
  def add_first_third_miss(results)
    return if results[1].nil? || results[3].nil?
    n = results[1] || results[3] ? 1 : 0
    @advice[:first_third_wrong][n] += 1
  end

  # 3a - From third: chance player is right and first and second both miss.
  def add_player_right_first_second_miss(results)
    return if results[0].nil? || results[1].nil? || results[2].nil?
    n = results[0] && !results[1] && !results[2] ? 0 : 1
    @advice[:player_right_first_second_wrong][n] += 1
  end

  # 3b - From third: chance first and second miss.
  def add_first_second_miss(results)
    return if results[1].nil? || results[2].nil?
    n = results[1] || results[2] ? 1 : 0
    @advice[:first_second_wrong][n] += 1
  end
end
