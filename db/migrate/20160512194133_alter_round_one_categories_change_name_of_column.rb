class AlterRoundOneCategoriesChangeNameOfColumn < ActiveRecord::Migration
  def change
    change_table :round_one_categories do |t|
      t.rename :column, :board_position
    end
  end
end
