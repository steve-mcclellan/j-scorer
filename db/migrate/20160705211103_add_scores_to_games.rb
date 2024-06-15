class AddScoresToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :round_one_score, :integer
    add_column :games, :round_two_score, :integer
    add_column :games, :final_result, :integer
  end
end
