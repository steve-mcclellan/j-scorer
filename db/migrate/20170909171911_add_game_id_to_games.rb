class AddGameIdToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :game_id, :string

    reversible do |dir|
      dir.up do
        Game.update_all 'game_id = show_date'
      end

      dir.down do
      end
    end

    change_column_null :games, :game_id, false
    add_index :games, [:user_id, :game_id], unique: true
  end
end
