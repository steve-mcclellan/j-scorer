class Sixth < ActiveRecord::Base
  belongs_to :game, inverse_of: :sixths, touch: true

  validates :game, presence: true
  validates :board_position,
            presence: true,
            inclusion: { in: [1, 2, 3, 4, 5, 6] },
            uniqueness: { scope: [:game_id, :type],
                          message: 'already exists' }

  default_scope { order(type: :asc, board_position: :asc) }

  include Topicable

  def self.types
    %w(RoundOneCategory RoundTwoCategory)
  end

  scope :round_one_categories, -> { where(type: 'RoundOneCategory') }
  scope :round_two_categories, -> { where(type: 'RoundTwoCategory') }
end
