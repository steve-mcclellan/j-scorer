class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :email, index: true, unique: true

      t.timestamps null: false
    end
  end
end
