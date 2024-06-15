class AlterGamesMakeShowDateIndexUnique < ActiveRecord::Migration[4.2]
  def change
    remove_index :games, [:user_id, :show_date]
    add_index :games, [:user_id, :show_date], unique: true
  end
end
