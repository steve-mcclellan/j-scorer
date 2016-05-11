class Game < ActiveRecord::Base
  belongs_to :user

  default_scope -> { order(date_played: :desc) }

  validates :user_id, presence: true
  validates :show_date, presence: true
end
