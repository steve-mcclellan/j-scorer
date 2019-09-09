class AlterTopicsMakeIndexBeOnLower < ActiveRecord::Migration[6.0]
  def change
    remove_index :topics, column: [:user_id, :name]
    add_index :topics, 'lower(name), user_id', unique: true
  end
end
