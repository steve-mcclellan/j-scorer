class Topic < ApplicationRecord
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

  def round_one_stats(play_types)
    main_game_stats(play_types, 1)
  end

  def round_two_stats(play_types)
    main_game_stats(play_types, 2)
  end

  # Provides a stats summary for either or both of the first two rounds.
  # Returns stats for round one or two only if passed the corresponding
  # integer, otherwise returns stats for both rounds.
  def main_game_stats(play_types, round = nil)
    stats = { right: 0, wrong: 0, pass: 0, score: 0, possible_score: 0,
              dd_right: 0, dd_wrong: 0 }

    categories = case round
                 when 1 then round_one_categories
                 when 2 then round_two_categories
                 else sixths
                 end

    cats = categories.joins(:game).where(games: { play_type: play_types })
    cats.each { |cat| update_stats(stats, cat) }

    stats
  end

  def categories_tracked(play_types)
    s = sixths.joins(:game).where(games: { play_type: play_types }).count
    f = finals.joins(:game).where(games: { play_type: play_types }).count
    s + f
  end

  def finals_right(play_types)
    finals.joins(:game).where(games: { play_type: play_types }, result: 3).count
  end

  def finals_wrong(play_types)
    finals.joins(:game).where(games: { play_type: play_types }, result: 1).count
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
    return stats[:dd_right] += 1 if result == 7
    stats[:dd_wrong] += 1
  end
end
