class AlterSixthsAddIndexOnGameId < ActiveRecord::Migration
  def change
    add_index :sixths, :game_id
  end
end
