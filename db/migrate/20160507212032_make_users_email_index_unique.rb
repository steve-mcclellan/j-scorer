class MakeUsersEmailIndexUnique < ActiveRecord::Migration
  def change
    remove_index :users, :email
    add_index :users, :email, unique: true
  end
end
