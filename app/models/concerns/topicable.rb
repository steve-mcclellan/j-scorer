module Topicable
  extend ActiveSupport::Concern

  included do
    has_many :category_topics, as: :category, dependent: :destroy
    has_many :topics, through: :category_topics

    before_save :modify_topics
  end

  private

  def modify_topics
    # TODO
    # - Make sure topic string exists.
    # - ts.strip!
    # - ts.squeeze!(' ')
    # - ts.gsub!(/\s?,\s?, ',')
    # - topic_list = ts.split(',')
    # - ts.gsub!(',', ', ')
    # - cat.topics = topic_list
    # - Make sure return value is truthy.
  end

  def topics_string
    # TODO: Put first and last topics in proper position.
    topics.map(&:name).join(', ')
  end
end
