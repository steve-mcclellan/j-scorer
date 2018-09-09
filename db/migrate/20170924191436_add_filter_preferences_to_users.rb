class AddFilterPreferencesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :show_date_reverse, :boolean
    add_column :users, :show_date_preposition, :string, limit: 10
    add_column :users, :show_date_beginning, :date
    add_column :users, :show_date_last_number, :float
    add_column :users, :show_date_last_unit, :string, limit: 1
    add_column :users, :show_date_from, :date
    add_column :users, :show_date_to, :date
    add_column :users, :show_date_weight, :string, limit: 10
    add_column :users, :show_date_half_life, :float
    add_column :users, :date_played_reverse, :boolean
    add_column :users, :date_played_preposition, :string, limit: 10
    add_column :users, :date_played_beginning, :date
    add_column :users, :date_played_last_number, :float
    add_column :users, :date_played_last_unit, :string, limit: 1
    add_column :users, :date_played_from, :date
    add_column :users, :date_played_to, :date
    add_column :users, :date_played_weight, :string, limit: 10
    add_column :users, :date_played_half_life, :float
  end
end
