class Game < ActiveRecord::Base
  belongs_to :user, touch: true
  # has_many :round_one_categories, dependent: :destroy
  # has_many :round_two_categories, dependent: :destroy
  has_many :sixths, dependent: :destroy
  has_one :final, dependent: :destroy

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope -> { order(date_played: :desc) }

  validates :user_id, presence: true
  validates :show_date, presence: true, uniqueness: { scope: :user_id }
end
