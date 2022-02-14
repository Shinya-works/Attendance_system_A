class AddOverworkColumToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :expected_end_time, :time
    add_column :attendances, :business_processing_details, :string
    add_column :attendances, :overwork_authentication_user, :string
    add_column :attendances, :edit_authentication_user, :string
    add_column :attendances, :attendances_authentication_user, :string
    add_column :attendances, :authentication_state_overwork, :string
    add_column :attendances, :authentication_state_edit, :string
    add_column :attendances, :authentication_state_attendances, :string
  end
end
