class CategoryTopic < ActiveRecord::Base
  belongs_to :category, polymorphic: true
  belongs_to :topic
end
