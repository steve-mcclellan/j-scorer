class CategoryTopic < ApplicationRecord
  belongs_to :category, polymorphic: true, touch: true
  belongs_to :topic, touch: true

  validates :topic_id,
            presence: true,
            uniqueness: { scope: [:category_id, :category_type] }

  validates :category_id, presence: true
  validates :category_type, presence: true

  validate :category_and_topic_must_belong_to_same_user

  private

  def category_and_topic_must_belong_to_same_user
    return unless category && topic && category.game.user != topic.user
    errors.add(:topic, "can't belong to a different user than game")
  end
end
