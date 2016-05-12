class CreateCategoryTopics < ActiveRecord::Migration
  def change
    create_table :category_topics do |t|
      t.references :category, polymorphic: true, index: true
      t.references :topic, index: true, foreign_key: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
