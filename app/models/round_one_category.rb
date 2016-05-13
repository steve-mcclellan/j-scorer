class RoundOneCategory < ActiveRecord::Base
  belongs_to :game, touch: true

  include Topicable
end
