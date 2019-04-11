class PercentileReport
  include SharedStatsMethods

  attr_reader :stats

  PERCENTILES_TO_SHOW = [1, 5, 10, 25, 50, 75, 90, 95, 99].freeze

  def initialize(user, play_types, filters)
    query = percentile_query(user, play_types, filters)
    games = ActiveRecord::Base.connection.select_all(query).to_a

    games.map! { |g| { score: g['score'].to_i, weight: g['weight'].to_f } }

    @stats = Hash.new('---')
    return if games.empty?

    @stats[:max] = games[0][:score]
    @stats[:min] = games[-1][:score]
    get_percentiles(games)
  end

  private

  # rubocop:disable MethodLength
  def percentile_query(user, play_types, other_filters)
    validate_query_inputs(user, play_types)
    play_types_list = format_play_types_for_sql(play_types)
    "
    SELECT
      (
        (g.round_one_score * #{CURRENT_TOP_ROW_VALUES[0]}) +
        (g.round_two_score * #{CURRENT_TOP_ROW_VALUES[1]})
      ) AS score,
      1.0 AS weight
    FROM games g
    WHERE
      g.user_id = #{user.id}
      AND g.play_type IN (#{play_types_list})
      #{other_filters}
    ORDER BY score DESC
    "
  end
  # rubocop:enable MethodLength

  def get_percentiles(games)
    weight_so_far = 0.0
    total_weight = games.reduce(0) { |acc, elem| acc + elem[:weight] }
    percentiles = PERCENTILES_TO_SHOW.map { |p| [p, total_weight * p / 100] }
    percentiles.each do |percentile|
      score, weight_so_far = get_percentile(percentile, games, weight_so_far)
      @stats[('p' + percentile[0].to_s).to_sym] = score
    end
  end

  def get_percentile(percentile, games, weight_so_far)
    weight_with_this_game = weight_so_far + games[-1][:weight]
    if weight_with_this_game > percentile[1]
      [games[-1][:score], weight_so_far]
    elsif weight_with_this_game == percentile[1]
      gm = games.pop
      [(gm[:score] + games[-1][:score]) / 2, weight_so_far + gm[:weight]]
    else
      weight_so_far += games.pop[:weight]
      get_percentile(percentile, games, weight_so_far)
    end
  end
end
