class CreateRoundOneCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :round_one_categories do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :column
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
