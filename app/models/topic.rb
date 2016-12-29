class Topic < ApplicationRecord
  belongs_to :user, touch: true

  has_many :category_topics, dependent: :destroy

  has_many :sixths,
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :round_one_categories,
           -> { where type: 'RoundOneCategory' },
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :round_two_categories,
           -> { where type: 'RoundTwoCategory' },
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :finals,
           through:     :category_topics,
           source:      :category,
           source_type: 'Final'

  validates :user_id, presence: true

  validates :name,
            presence: true,
            uniqueness: { scope: :user_id, case_sensitive: false }
end
