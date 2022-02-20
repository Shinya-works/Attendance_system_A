class AddCheckboxToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :string
    add_column :attendances, :update_authentication, :string
    add_column :attendances, :attendances_authentication, :string
    add_column :attendances, :overwork_authentication, :string
    add_column :attendances, :edit_next_day, :string
  end
end
