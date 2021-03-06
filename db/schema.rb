# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220131134513) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.datetime "edit_started_at"
    t.datetime "edit_finished_at"
    t.datetime "before_change_started_at"
    t.datetime "before_change_finished_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "expected_end_time"
    t.string "business_processing_details"
    t.string "overwork_authentication_user"
    t.string "edit_authentication_user"
    t.string "attendances_authentication_user"
    t.string "authentication_state_overwork"
    t.string "authentication_state_edit"
    t.string "authentication_state_attendances"
    t.string "next_day"
    t.string "update_authentication"
    t.string "attendances_authentication"
    t.string "overwork_authentication"
    t.string "edit_next_day"
    t.string "attendances_log"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.integer "base_number"
    t.string "base_name"
    t.string "time_type"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "affiliation"
    t.string "remember_digest"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.boolean "superiors", default: false
    t.integer "employee_number"
    t.string "uid"
    t.time "basic_work_time", default: "2000-01-01 23:00:00"
    t.time "designated_work_start_time", default: "2000-01-01 00:00:00"
    t.time "designated_work_end_time", default: "2000-01-01 08:00:00"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
