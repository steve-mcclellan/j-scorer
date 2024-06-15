class CreateFinals < ActiveRecord::Migration[4.2]
  def change
    create_table :finals do |t|
      t.references :game, index: true, foreign_key: true
      t.string :category_title
      t.integer :result

      t.timestamps null: false
    end
  end
end
