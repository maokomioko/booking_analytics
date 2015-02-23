# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150223143014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "beddings", force: :cascade do |t|
    t.integer "room_id"
  end

  create_table "beds", force: :cascade do |t|
    t.string  "amount"
    t.string  "type"
    t.integer "bedding_id"
  end

  create_table "block_availabilities", force: :cascade do |t|
    t.string   "departure_date"
    t.string   "arrival_date"
    t.string   "max_occupancy"
    t.jsonb    "data"
    t.integer  "hotel_id"
    t.integer  "booking_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "block_availabilities", ["booking_id"], name: "index_block_availabilities_on_booking_id", using: :btree
  add_index "block_availabilities", ["hotel_id"], name: "index_block_availabilities_on_hotel_id", using: :btree

  create_table "blocks", force: :cascade do |t|
    t.string   "name"
    t.string   "max_occupancy"
    t.integer  "block_availability_id"
    t.string   "block_id",              limit: 40
    t.boolean  "refundable"
    t.string   "refundable_until"
    t.boolean  "deposit_required"
    t.boolean  "breakfast_included"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blocks", ["block_availability_id"], name: "index_blocks_on_block_availability_id", using: :btree
  add_index "blocks", ["block_id"], name: "index_blocks_on_block_id", using: :btree

  create_table "checkouts", force: :cascade do |t|
    t.string  "from"
    t.string  "to"
    t.integer "hotel_id"
  end

  add_index "checkouts", ["hotel_id"], name: "index_checkouts_on_hotel_id", using: :btree

  create_table "chekins", force: :cascade do |t|
    t.string  "to"
    t.string  "from"
    t.integer "hotel_id"
  end

  add_index "chekins", ["hotel_id"], name: "index_chekins_on_hotel_id", using: :btree

  create_table "hotel_facilities", force: :cascade do |t|
    t.string  "name"
    t.integer "count", default: 0
  end

  create_table "hotel_facilities_hotels", id: false, force: :cascade do |t|
    t.integer "hotel_facility_id"
    t.integer "hotel_id"
  end

  add_index "hotel_facilities_hotels", ["hotel_facility_id", "hotel_id"], name: "index_hotel_facilities_hotels_on_hotel_facility_id_and_hotel_id", using: :btree
  add_index "hotel_facilities_hotels", ["hotel_id"], name: "index_hotel_facilities_hotels_on_hotel_id", using: :btree

  create_table "hotels", force: :cascade do |t|
    t.string  "name"
    t.string  "hoteltype_id"
    t.string  "city"
    t.string  "city_id"
    t.string  "address"
    t.string  "url"
    t.float   "exact_class"
    t.float   "review_score"
    t.string  "district"
    t.string  "zip"
    t.integer "booking_id"
  end

  add_index "hotels", ["booking_id"], name: "index_hotels_on_booking_id", using: :btree

  create_table "incremental_prices", force: :cascade do |t|
    t.string  "price_currency", default: "EUR"
    t.integer "price_cents"
    t.integer "block_id"
  end

  add_index "incremental_prices", ["block_id"], name: "index_incremental_prices_on_block_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "latitude"
    t.string  "longitude"
    t.integer "hotel_id"
  end

  add_index "locations", ["hotel_id"], name: "index_locations_on_hotel_id", using: :btree

  create_table "related_hotels", force: :cascade do |t|
    t.integer "hotel_id"
    t.integer "related_id"
  end

  add_index "related_hotels", ["hotel_id"], name: "index_related_hotels_on_hotel_id", using: :btree
  add_index "related_hotels", ["related_id", "hotel_id"], name: "index_related_hotels_on_related_id_and_hotel_id", unique: true, using: :btree

  create_table "room_facilities", force: :cascade do |t|
    t.string  "name"
    t.integer "count", default: 0
  end

  create_table "room_facilities_rooms", id: false, force: :cascade do |t|
    t.integer "room_facility_id"
    t.integer "room_id"
  end

  add_index "room_facilities_rooms", ["room_facility_id", "room_id"], name: "index_room_facilities_rooms_on_room_facility_id_and_room_id", using: :btree
  add_index "room_facilities_rooms", ["room_id"], name: "index_room_facilities_rooms_on_room_id", using: :btree

  create_table "room_prices", force: :cascade do |t|
    t.date    "date"
    t.integer "default_price_cents"
    t.integer "price_cents"
    t.boolean "enabled"
    t.boolean "locked"
    t.integer "room_id"
    t.string  "price_currency",         default: "EUR"
    t.string  "default_price_currency", default: "EUR"
  end

  create_table "rooms", force: :cascade do |t|
    t.string  "roomtype"
    t.integer "max_price_cents"
    t.integer "min_price_cents"
    t.integer "hotel_id"
    t.string  "name"
    t.integer "availability"
    t.integer "occupancy"
    t.integer "children"
    t.integer "wubook_auth_id"
    t.integer "subroom"
    t.integer "max_people"
    t.float   "price"
    t.string  "min_price_currency", default: "EUR"
    t.string  "max_price_currency", default: "EUR"
  end

  add_index "rooms", ["hotel_id"], name: "index_rooms_on_hotel_id", using: :btree
  add_index "rooms", ["wubook_auth_id"], name: "index_rooms_on_wubook_auth_id", using: :btree

  create_table "rooms_wubook_auths", force: :cascade do |t|
    t.integer "room_id"
    t.integer "wubook_auth_id"
  end

  add_index "rooms_wubook_auths", ["room_id", "wubook_auth_id"], name: "index_rooms_wubook_auths_on_room_id_and_wubook_auth_id", unique: true, using: :btree
  add_index "rooms_wubook_auths", ["wubook_auth_id"], name: "index_rooms_wubook_auths_on_wubook_auth_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "wb_auth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wubook_auths", force: :cascade do |t|
    t.string  "login"
    t.string  "password"
    t.string  "lcode"
    t.integer "booking_id"
    t.string  "hotel_name"
    t.integer "non_refundable_pid"
    t.integer "default_pid"
    t.integer "user_id"
  end

  add_index "wubook_auths", ["user_id"], name: "index_wubook_auths_on_user_id", using: :btree

end
