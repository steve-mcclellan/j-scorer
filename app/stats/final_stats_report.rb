class FinalStatsReport
  include FinalQueries, SharedStatsMethods

  attr_reader :stats

  def initialize(user, play_types)
    raw_data = ActiveRecord::Base.connection
                                 .select_all(final_query(user, play_types))
                                 .to_hash[0]

    @stats = format_data(raw_data)
    # rubocop:disable SpaceAroundOperators
    moe_pct = [(98.0 * (@stats[:contestants][2][1] ** -0.5)), 100].min
    # rubocop:enable SpaceAroundOperators
    @stats[:advice][:moe_pct] = moe_pct
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
end
