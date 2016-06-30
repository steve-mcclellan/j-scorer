class FinalSerializer < ActiveModel::Serializer
  attributes :category_title,
             :topic_string,
             :result,
             :contestants_right,
             :contestants_wrong
end
