class AddContestantResultsToFinals < ActiveRecord::Migration
  def change
    add_column :finals, :contestants_right, :integer
    add_column :finals, :contestants_wrong, :integer
  end
end
