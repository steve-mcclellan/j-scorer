class AlterPlayTypeIndexOnGames < ActiveRecord::Migration[4.2]
  def change
    remove_index :games, :play_type
    add_index :games, [:user_id, :play_type]
  end
end
