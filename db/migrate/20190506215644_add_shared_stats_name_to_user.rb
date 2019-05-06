class AddSharedStatsNameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :shared_stats_name, :string
    add_index :users, 'lower(shared_stats_name)', unique: true
  end
end
