class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :user, index: true, foreign_key: true
      t.date :show_date
      t.datetime :date_played

      t.timestamps null: false
    end
    add_index :games, [:user_id, :date_played]
    add_index :games, [:user_id, :show_date]
  end
end
