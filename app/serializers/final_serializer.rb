class FinalSerializer < ActiveModel::Serializer
  attributes :id,
             :category_title,
             :topics_string,
             :result,
             :contestants_right,
             :contestants_wrong
end
