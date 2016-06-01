class RemovePlacementFromCategoryTopics < ActiveRecord::Migration
  def change
    remove_column :category_topics, :placement, :integer
  end
end
