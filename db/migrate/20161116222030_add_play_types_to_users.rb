class AddPlayTypesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :play_types, :string, array: true, default: ["regular"]
  end
end
