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

ActiveRecord::Schema.define(version: 20150407100043) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hotels", force: :cascade do |t|
    t.string  "name"
    t.float   "exact_class"
    t.float   "review_score"
    t.integer "booking_id"
  end

  create_table "room_prices", force: :cascade do |t|
    t.integer "room_id"
    t.date    "date"
    t.integer "price_cents"
    t.string  "price_currency", default: "EUR"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "max_price_cents"
    t.string   "max_price_currency", default: "EUR"
    t.integer  "min_price_cents"
    t.string   "min_price_currency", default: "EUR"
    t.integer  "booking_id"
    t.integer  "booking_hotel_id"
    t.integer  "hotel_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", force: :cascade do |t|
    t.jsonb   "data"
    t.text    "max_occupancy", default: [], array: true
    t.integer "booking_id"
  end

  add_index "sources", ["booking_id"], name: "index_sources_on_booking_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "email"
  end

end
