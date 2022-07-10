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

ActiveRecord::Schema[7.0].define(version: 2022_07_09_200551) do
  create_table "attentions", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_states", force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.string "notes"
    t.integer "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_device_states_on_device_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_devices_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "websocket_ip", null: false
    t.string "websocket_port", null: false
    t.string "facility_id", null: false
    t.string "building", null: false
    t.string "room_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "building_nickname"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "uniqname", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uniqname"], name: "index_users_on_uniqname", unique: true
  end

  add_foreign_key "device_states", "devices"
  add_foreign_key "devices", "rooms"
end
