class AlterGamesMakeShowDateIndexUnique < ActiveRecord::Migration
  def change
    remove_index :games, [:user_id, :show_date]
    add_index :games, [:user_id, :show_date], unique: true
  end
end
