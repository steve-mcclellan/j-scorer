class AlterGamesAddIndexOnOnlyPlayType < ActiveRecord::Migration[4.2]
  def change
    add_index :games, :play_type
  end
end
