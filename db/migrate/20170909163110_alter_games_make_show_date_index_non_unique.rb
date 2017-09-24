class AlterGamesMakeShowDateIndexNonUnique < ActiveRecord::Migration[5.0]
  def change
    remove_index :games, [:user_id, :show_date]  # This was a unique index
    add_index :games, [:user_id, :show_date]
  end
end
