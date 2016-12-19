# This module relies on valid_types? from the SharedStatsMethods module.
module FinalQueries
  def final_query(user, play_types)
    raise ArgumentError unless user.is_a?(User) && valid_types?(play_types)
    play_types_list = play_types.map { |x| "'#{x}'" }.join(', ')

    "
    SELECT f.result, f.first_right, f.second_right, f.third_right
    FROM finals f
    INNER JOIN games g ON g.id = f.game_id
    WHERE g.user_id = #{user.id} AND g.play_type IN (#{play_types_list})
      AND f.result IN (1, 3)
    "
  end
end
