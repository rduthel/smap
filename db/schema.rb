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

ActiveRecord::Schema.define(version: 20180226173005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "additional_drivers", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "telephone_number"
    t.string "email"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "driving_license"
    t.string "identity_card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_profile_id"
    t.index ["driver_profile_id"], name: "index_additional_drivers_on_driver_profile_id"
  end

  create_table "addresses", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "driver_profile_id"
    t.index ["driver_profile_id"], name: "index_addresses_on_driver_profile_id"
  end

  create_table "cars", force: :cascade do |t|
    t.string "category"
    t.string "brand"
    t.string "model"
    t.string "energy"
    t.integer "monthly_price"
    t.integer "seat"
    t.integer "lugage"
    t.string "transmission"
    t.string "engine"
    t.integer "car_door"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "driver_profiles", force: :cascade do |t|
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "telephone_number"
    t.string "email"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.bigint "car_id"
    t.string "driving_license"
    t.string "identity_card"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_driver_profiles_on_car_id"
    t.index ["user_id"], name: "index_driver_profiles_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "car_id"
    t.string "user"
    t.integer "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_ratings_on_car_id"
  end

  create_table "slots", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.bigint "address_id"
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_slots_on_address_id"
    t.index ["car_id"], name: "index_slots_on_car_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "additional_drivers", "driver_profiles"
  add_foreign_key "addresses", "driver_profiles"
  add_foreign_key "driver_profiles", "cars"
  add_foreign_key "driver_profiles", "users"
  add_foreign_key "ratings", "cars"
  add_foreign_key "slots", "addresses"
  add_foreign_key "slots", "cars"
end
