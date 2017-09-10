class AddRerunToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :rerun, :boolean, null: false, default: false
    add_index :games, [:user_id, :rerun]
  end
end
