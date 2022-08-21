class AddBoxScoreStatsToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :clues_right, :integer
    add_column :games, :clues_wrong, :integer
  end
end
