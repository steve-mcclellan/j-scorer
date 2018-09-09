class AddRerunFilterPreferenceToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rerun_status, :integer, null: false, default: 0
  end
end
