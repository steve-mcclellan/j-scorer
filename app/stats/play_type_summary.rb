class PlayTypeSummary
  include SharedStatsMethods

  attr_reader :stats

  def initialize(user)
    raise ArgumentError unless user.is_a?(User)

    query = "
      SELECT play_type,
        (round_one_score * #{CURRENT_TOP_ROW_VALUES[0]}) +
        (round_two_score * #{CURRENT_TOP_ROW_VALUES[1]}) AS game_score
      FROM games WHERE user_id = #{user.id}
      ORDER BY play_type ASC
    "

    data = ActiveRecord::Base.connection.select_all(query).to_hash

    crunch_numbers(data)
  end

  private

  def crunch_numbers(data)
    @stats = Hash.new do |hash, key|
      hash[key] = { games_count: 0, total_score: 0,
                    min: Float::INFINITY, max: -Float::INFINITY }
    end

    data.each { |game_hash| add_game_to_stats(game_hash) }

    add_averages
  end

  def add_game_to_stats(game_hash)
    type_stats = @stats[game_hash['play_type']]
    game_score = game_hash['game_score'].to_i

    type_stats[:games_count] += 1
    type_stats[:total_score] += game_score
    type_stats[:min] = [type_stats[:min], game_score].min
    type_stats[:max] = [type_stats[:max], game_score].max
  end

  def add_averages
    @stats.each_value do |type_stats|
      type_stats[:average_score] = quotient(type_stats[:total_score],
                                            type_stats[:games_count])
    end
  end
end
