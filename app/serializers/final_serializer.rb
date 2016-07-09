class FinalSerializer < ActiveModel::Serializer
  attributes :id,
             :category_title,
             :topics_string,
             :result,
             :third_right,
             :second_right,
             :first_right
end
