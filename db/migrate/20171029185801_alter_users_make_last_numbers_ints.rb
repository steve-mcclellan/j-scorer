class AlterUsersMakeLastNumbersInts < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        change_column :users, :show_date_last_number, :integer
        change_column :users, :date_played_last_number, :integer
      end

      dir.down do
        change_column :users, :show_date_last_number, :float
        change_column :users, :date_played_last_number, :float
      end
    end
  end
end
