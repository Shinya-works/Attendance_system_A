class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.datetime :edit_started_at
      t.datetime :edit_finished_at
      t.datetime :before_change_started_at
      t.datetime :before_change_finished_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
