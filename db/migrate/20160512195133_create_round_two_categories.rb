class CreateRoundTwoCategories < ActiveRecord::Migration
  def change
    create_table :round_two_categories do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :board_position
      t.string :title
      t.integer :result1
      t.integer :result2
      t.integer :result3
      t.integer :result4
      t.integer :result5

      t.timestamps null: false
    end
  end
end
