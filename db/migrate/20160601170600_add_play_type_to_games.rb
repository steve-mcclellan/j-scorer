class AddPlayTypeToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :play_type, :string
    add_index :games, :play_type
  end
end
