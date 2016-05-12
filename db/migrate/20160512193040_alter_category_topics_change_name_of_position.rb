class AlterCategoryTopicsChangeNameOfPosition < ActiveRecord::Migration
  def change
    change_table :category_topics do |t|
      t.rename :position, :placement
    end
  end
end
