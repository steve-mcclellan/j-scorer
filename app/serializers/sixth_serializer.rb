class SixthSerializer < ActiveModel::Serializer
  attributes :id,
             :board_position,
             :title,
             :topics_string,
             :result1,
             :result2,
             :result3,
             :result4,
             :result5
end
