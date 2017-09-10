class AlterGamesRemoveIndexOnOnlyPlayType < ActiveRecord::Migration[5.0]
  def change
    remove_index :games, :play_type
  end
end
