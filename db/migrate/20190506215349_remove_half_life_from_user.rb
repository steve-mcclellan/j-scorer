class RemoveHalfLifeFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :show_date_weight, :string
    remove_column :users, :show_date_half_life, :float
    remove_column :users, :date_played_weight, :string
    remove_column :users, :date_played_half_life, :float
  end
end
