class AddTopicsStringToFinals < ActiveRecord::Migration[4.2]
  def change
    add_column :finals, :topics_string, :string

    remove_column :finals, :first_topic, :string
    remove_column :finals, :last_topic, :string
  end
end
