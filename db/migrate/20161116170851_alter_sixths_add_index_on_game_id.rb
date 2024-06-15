class AlterSixthsAddIndexOnGameId < ActiveRecord::Migration[4.2]
  def change
    add_index :sixths, :game_id
  end
end
