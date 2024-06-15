class AlterRoundOneCategoriesChangeNameOfColumn < ActiveRecord::Migration[4.2]
  def change
    change_table :round_one_categories do |t|
      t.rename :column, :board_position
    end
  end
end
