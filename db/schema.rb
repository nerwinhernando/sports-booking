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

ActiveRecord::Schema[8.1].define(version: 2025_12_21_232158) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.boolean "active"
    t.text "address"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "owner_email"
    t.string "owner_name"
    t.string "phone"
    t.string "plan"
    t.string "province"
    t.json "settings"
    t.string "subdomain"
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "amount_cents"
    t.bigint "court_id", null: false
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.text "notes"
    t.string "payment_method"
    t.string "payment_reference"
    t.bigint "schedule_id", null: false
    t.datetime "start_time"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_bookings_on_account_id"
    t.index ["court_id"], name: "index_bookings_on_court_id"
    t.index ["schedule_id"], name: "index_bookings_on_schedule_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "courts", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "active"
    t.decimal "ceiling_height"
    t.string "court_number", null: false
    t.string "court_type", default: "standard"
    t.datetime "created_at", null: false
    t.string "floor_type"
    t.boolean "has_air_conditioning", default: false
    t.string "lighting_type"
    t.decimal "price_per_hour", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "venue_id", null: false
    t.index ["account_id"], name: "index_courts_on_account_id"
    t.index ["venue_id", "court_number"], name: "index_courts_on_venue_id_and_court_number", unique: true
    t.index ["venue_id"], name: "index_courts_on_venue_id"
  end

  create_table "pricing_rules", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "day_type"
    t.time "end_time"
    t.integer "price_per_hour_cents"
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.bigint "venue_id", null: false
    t.index ["account_id"], name: "index_pricing_rules_on_account_id"
    t.index ["venue_id"], name: "index_pricing_rules_on_venue_id"
  end

  create_table "schedule_templates", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "day_of_week"
    t.string "day_type"
    t.time "end_time"
    t.boolean "is_peak_hour"
    t.string "name"
    t.integer "price_cents"
    t.integer "slot_duration_minutes"
    t.time "start_time"
    t.datetime "updated_at", null: false
    t.bigint "venue_id", null: false
    t.index ["account_id"], name: "index_schedule_templates_on_account_id"
    t.index ["venue_id"], name: "index_schedule_templates_on_venue_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "court_id", null: false
    t.datetime "created_at", null: false
    t.string "day_type"
    t.time "end_time"
    t.boolean "is_peak_hour"
    t.integer "max_bookings"
    t.integer "price_cents"
    t.date "schedule_date"
    t.time "start_time"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_schedules_on_account_id"
    t.index ["court_id"], name: "index_schedules_on_court_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id"
    t.boolean "active", default: true
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.integer "loyalty_points", default: 0
    t.string "phone"
    t.string "player_type"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "customer"
    t.integer "sign_in_count", default: 0, null: false
    t.string "skill_level"
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "venues", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "active"
    t.text "address"
    t.string "barangay"
    t.string "city"
    t.datetime "created_at", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "municipality"
    t.string "name"
    t.string "phone"
    t.string "province"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_venues_on_account_id"
  end

  add_foreign_key "bookings", "accounts"
  add_foreign_key "bookings", "courts"
  add_foreign_key "bookings", "schedules"
  add_foreign_key "bookings", "users"
  add_foreign_key "courts", "accounts"
  add_foreign_key "courts", "venues"
  add_foreign_key "pricing_rules", "accounts"
  add_foreign_key "pricing_rules", "venues"
  add_foreign_key "schedule_templates", "accounts"
  add_foreign_key "schedule_templates", "venues"
  add_foreign_key "schedules", "accounts"
  add_foreign_key "schedules", "courts"
  add_foreign_key "users", "accounts"
  add_foreign_key "venues", "accounts"
end
