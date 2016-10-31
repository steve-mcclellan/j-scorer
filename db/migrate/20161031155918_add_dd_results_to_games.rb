class AddDdResultsToGames < ActiveRecord::Migration
  def change
    add_column :games, :dd1_result, :integer
    add_column :games, :dd2a_result, :integer
    add_column :games, :dd2b_result, :integer
  end
end
