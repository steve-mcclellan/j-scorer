class CategoryTopic < ActiveRecord::Base
  belongs_to :category, polymorphic: true, touch: true
  belongs_to :topic, touch: true

  validates :topic_id,
            presence: true,
            uniqueness: { scope: [:category_id, :category_type] }

  validates :category_id, presence: true
  validates :category_type, presence: true

  validates :placement,
            presence: true,
            numericality: { greater_than: 0 },
            uniqueness: { scope: [:category_id, :category_type] }

  validate :category_and_topic_must_belong_to_same_user

  def category_and_topic_must_belong_to_same_user
    if category && topic && category.game.user != topic.user
      errors.add(:topic, "can't belong to a different user than game")
    end
  end
end
