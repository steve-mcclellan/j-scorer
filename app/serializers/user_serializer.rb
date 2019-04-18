class UserSerializer < ActiveModel::Serializer
  has_many :games, key: :games_attributes
  class GameSerializer < ActiveModel::Serializer
    has_many :sixths, key: :sixths_attributes
    class SixthSerializer < ActiveModel::Serializer
      attributes :type,
                 :board_position,
                 :title,
                 :topics_string,
                 :result1,
                 :result2,
                 :result3,
                 :result4,
                 :result5
    end
    has_one :final, key: :final_attributes
    class FinalSerializer < ActiveModel::Serializer
      attributes :category_title,
                 :topics_string,
                 :result,
                 :third_right,
                 :second_right,
                 :first_right
    end

    attributes :show_date, :date_played, :play_type, :rerun,
               :round_one_score, :round_two_score, :final_result,
               :dd1_result, :dd2a_result, :dd2b_result
  end
end
