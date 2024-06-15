class AddTopicsStringToSixths < ActiveRecord::Migration[4.2]
  def change
    add_column :sixths, :topics_string, :string

    remove_column :sixths, :first_topic, :string
    remove_column :sixths, :last_topic, :string
  end
end
