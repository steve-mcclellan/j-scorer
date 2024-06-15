class DropRoundOneCategoryRoundTwoCategory < ActiveRecord::Migration[4.2]
  def change
    drop_table :round_one_categories
    drop_table :round_two_categories
  end
end
