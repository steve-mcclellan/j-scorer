class AddShareDetailedStatsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users,
               :share_detailed_stats,
               :boolean,
               null: false,
               default: false
  end
end
