class CategoryTopic < ActiveRecord::Base
  belongs_to :category, polymorphic: true, touch: true
  belongs_to :topic, touch: true
end
