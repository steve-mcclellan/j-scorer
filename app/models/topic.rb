class Topic < ActiveRecord::Base
  belongs_to :user, touch: true

  has_many :category_topics, dependent: :destroy

  has_many :round_one_categories,
           through:     :category_topics,
           source:      :category,
           source_type: 'RoundOneCategory'

  has_many :round_two_categories,
           through:     :category_topics,
           source:      :category,
           source_type: 'RoundTwoCategory'

  has_many :finals,
           through:     :category_topics,
           source:      :category,
           source_type: 'Final'
end
