class AddEachContestantsResultsToFinals < ActiveRecord::Migration[4.2]
  def change
    add_column :finals, :first_right, :boolean
    add_column :finals, :second_right, :boolean
    add_column :finals, :third_right, :boolean

    remove_column :finals, :contestants_right, :integer
    remove_column :finals, :contestants_wrong, :integer
  end
end
