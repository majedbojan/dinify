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

ActiveRecord::Schema[8.1].define(version: 2025_09_29_132941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "uuid-ossp"

  create_table "restaurant_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "restaurant_id", null: false
    t.string "role", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["restaurant_id", "user_id"], name: "index_restaurant_users_on_restaurant_id_and_user_id", unique: true
    t.index ["restaurant_id"], name: "index_restaurant_users_on_restaurant_id"
    t.index ["role"], name: "index_restaurant_users_on_role"
    t.index ["status"], name: "index_restaurant_users_on_status"
    t.index ["user_id"], name: "index_restaurant_users_on_user_id"
  end

  create_table "restaurants", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "address"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "email"
    t.jsonb "metadata", default: {}, null: false
    t.string "name", null: false
    t.string "phone"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["email"], name: "index_restaurants_on_email"
    t.index ["name"], name: "index_restaurants_on_name"
    t.index ["status"], name: "index_restaurants_on_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "restaurant_users", "restaurants"
  add_foreign_key "restaurant_users", "users"
  add_foreign_key "sessions", "users"
end
