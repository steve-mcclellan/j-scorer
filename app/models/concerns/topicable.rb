module Topicable
  extend ActiveSupport::Concern

  included do
    has_many :category_topics, as: :category, dependent: :destroy
    has_many :topics, through: :category_topics
  end
end
