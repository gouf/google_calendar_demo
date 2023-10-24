# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_18_105844) do
  create_table "meeting_schedule_candidates", force: :cascade do |t|
    t.string "google_calendar_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
  end

  create_table "meeting_schedule_groups", force: :cascade do |t|
    t.integer "meeting_schedule_anchor_id", null: false
    t.integer "meeting_schedule_candidate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_schedule_anchor_id"], name: "index_meeting_schedule_groups_on_meeting_schedule_anchor_id"
    t.index ["meeting_schedule_candidate_id"], name: "index_meeting_schedule_groups_on_meeting_schedule_candidate_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "meeting_schedule_groups", "meeting_schedule_anchors"
  add_foreign_key "meeting_schedule_groups", "meeting_schedule_candidates"
end
