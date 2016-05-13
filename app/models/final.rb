class Final < ActiveRecord::Base
  belongs_to :game, touch: true

  validates :game_id, presence: true, uniqueness: true

  include Topicable
end
