class Topic < ActiveRecord::Base
  belongs_to :user, touch: true

  has_many :category_topics, dependent: :destroy

  has_many :sixths,
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :round_one_categories,
           -> { where type: 'RoundOneCategory' },
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :round_two_categories,
           -> { where type: 'RoundTwoCategory' },
           through:     :category_topics,
           source:      :category,
           source_type: 'Sixth'

  has_many :finals,
           through:     :category_topics,
           source:      :category,
           source_type: 'Final'

  validates :user_id, presence: true

  validates :name,
            presence: true,
            uniqueness: { scope: :user_id, case_sensitive: false }

  # def self.by_user_and_name(user, name)
  #   user.topics
  #       .where('lower(name) = ?', name.downcase)
  #       .first_or_create!(name: name)
  # end

  def round_one_stats
    main_game_stats(1)
  end

  def round_two_stats
    main_game_stats(2)
  end

  # Provides a stats summary for either or both of the first two rounds.
  # Returns stats for round one or two only if passed the corresponding
  # integer, otherwise returns stats for both rounds.
  # Note: score and possible_score are 1-based, not 200- or 400- based.
  # TODO: Incorporate round value differences. (Add top_row_value to Sixth?)
  def main_game_stats(round = nil)
    stats = { right: 0, wrong: 0, pass: 0, score: 0, possible_score: 0,
              dd_right: 0, dd_wrong: 0 }

    categories = case round
                 when 1 then round_one_categories
                 when 2 then round_two_categories
                 else sixths
                 end
    # categories = round == 1 ? round_one_categories : round_two_categories
    categories.each { |category| update_stats(stats, category) }

    stats
  end

  private

  def update_stats(stats, new_category)
    summary = new_category.summary
    [:right, :wrong, :pass, :score, :possible_score].each do |key|
      stats[key] += summary[key]
    end
    update_dd_stats(stats, summary[:dd_result]) if summary[:dd_position]
  end

  def update_dd_stats(stats, result)
    return stats[:dd_right] += 1 if result == :correct
    stats[:dd_wrong] += 1
  end
end
