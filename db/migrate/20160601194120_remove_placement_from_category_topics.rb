class RemovePlacementFromCategoryTopics < ActiveRecord::Migration[4.2]
  def change
    remove_column :category_topics, :placement, :integer
  end
end
