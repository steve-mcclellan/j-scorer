class Game < ActiveRecord::Base
  belongs_to :user, touch: true
  has_many :sixths, inverse_of: :game, dependent: :destroy
  has_one :final, inverse_of: :game, dependent: :destroy

  accepts_nested_attributes_for :sixths, :final

  delegate :round_one_categories, :round_two_categories, to: :sixths

  default_scope { order(date_played: :desc) }

  validates :user_id, presence: true
  validates :show_date, presence: true, uniqueness: { scope: :user_id }

  default_values show_date:   -> { Time.zone.today },
                 date_played: -> { Time.zone.now }

  def to_param
    show_date.to_s.parameterize
  end
end
