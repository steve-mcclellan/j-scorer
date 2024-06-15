class CreateSixths < ActiveRecord::Migration[4.2]
  def change
    create_table :sixths do |t|
      t.integer :game_id
      t.string :type
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
