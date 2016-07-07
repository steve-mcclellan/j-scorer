class Final < ActiveRecord::Base
  belongs_to :game, inverse_of: :final, touch: true

  validates :game, presence: true, uniqueness: { message: 'already exists' }

  include Topicable
end
