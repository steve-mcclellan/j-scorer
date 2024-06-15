class AlterCategoryTopicsChangeNameOfPosition < ActiveRecord::Migration[4.2]
  def change
    change_table :category_topics do |t|
      t.rename :position, :placement
    end
  end
end
