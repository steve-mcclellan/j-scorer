class AddContestantResultsToFinals < ActiveRecord::Migration[4.2]
  def change
    add_column :finals, :contestants_right, :integer
    add_column :finals, :contestants_wrong, :integer
  end
end
