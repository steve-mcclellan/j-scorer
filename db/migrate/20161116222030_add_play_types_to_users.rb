class AddPlayTypesToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :play_types, :string, array: true, default: ["regular"]
  end
end
