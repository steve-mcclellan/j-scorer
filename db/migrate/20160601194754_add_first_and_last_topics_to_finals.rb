class AddFirstAndLastTopicsToFinals < ActiveRecord::Migration[4.2]
  def change
    add_column :finals, :first_topic, :string
    add_column :finals, :last_topic, :string
  end
end
