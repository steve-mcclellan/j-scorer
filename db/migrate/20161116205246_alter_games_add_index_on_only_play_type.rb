class AlterGamesAddIndexOnOnlyPlayType < ActiveRecord::Migration
  def change
    add_index :games, :play_type
  end
end
