class Sixth < ActiveRecord::Base
  belongs_to :game, touch: true

  validates :game_id, presence: true
  validates :board_position,
            presence: true,
            inclusion: { in: [1, 2, 3, 4, 5, 6] },
            uniqueness: { scope: [:game_id, :type] }

  include Topicable

  def self.types
    %w(RoundOneCategory RoundTwoCategory)
  end

  scope :round_one_categories, -> { where(type: 'RoundOneCategory') }
  scope :round_two_categories, -> { where(type: 'RoundTwoCategory') }
end
