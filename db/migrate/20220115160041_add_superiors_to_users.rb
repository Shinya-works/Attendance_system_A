class AddSuperiorsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :superiors, :boolean, default: false
  end
end
