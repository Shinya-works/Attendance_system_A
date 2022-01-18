class AddUserInfoColumToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :integer
    add_column :users, :basic_work_time, :time
    add_column :users, :designated_work_start_time, :time
    add_column :users, :designated_work_end_time, :time
  end
end
