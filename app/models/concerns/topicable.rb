module Topicable
  extend ActiveSupport::Concern

  included do
    has_many :category_topics, as: :category, dependent: :destroy
    has_many :topics, through: :category_topics

    after_save :update_topics!
  end

  private

  def update_topics!
    topics_array = []
    topic_names_array.each do |topic_name|
      topic = game.user.topics.where('lower(name) = ?', topic_name.downcase)
                  .first_or_create(name: topic_name)
      topics_array << topic if topic.valid?
    end
    self.topics = topics_array
  end

  def topic_names_array
    return [] if topics_string.nil?
    topics_string.strip                 # Remove leading/trailing whitespace.
                 .squeeze(' ')          # Compress any consecutive spaces.
                 .gsub(/\s?,\s?/, ',')  # Remove any whitespace around commas.
                 .split(',')            # Convert to array of strings.
                 .uniq(&:downcase)      # Remove any duplicates from array.
  end
end
