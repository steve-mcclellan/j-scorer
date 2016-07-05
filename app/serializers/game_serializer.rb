class GameSerializer < ActiveModel::Serializer
  has_many :round_one_categories
  has_many :round_two_categories
  has_one :final

  attributes :show_date, :date_played, :play_type
end
