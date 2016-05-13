class CategoryTopic < ActiveRecord::Base
  belongs_to :category, polymorphic: true, touch: true
  belongs_to :topic, touch: true

  validates :topic_id, presence: true
  validates :category_id, presence: true
  validates :category_type, presence: true
  validates :placement, presence: true, numericality: { greater_than: 0 }
end
