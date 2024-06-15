class AddFirstAndLastTopicsToSixths < ActiveRecord::Migration[4.2]
  def change
    add_column :sixths, :first_topic, :string
    add_column :sixths, :last_topic, :string
  end
end
