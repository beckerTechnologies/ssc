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

ActiveRecord::Schema.define(version: 20140326001831) do

  create_table "auth_options", force: true do |t|
    t.text     "name"
    t.integer  "length"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_infos", force: true do |t|
    t.integer  "profile_id"
    t.text     "first_name"
    t.text     "middle_name"
    t.text     "last_name"
    t.date     "dob"
    t.text     "ssn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carriers", force: true do |t|
    t.string   "carrier_name"
    t.string   "carrier_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.text     "email"
    t.text     "password"
    t.text     "phone_number"
    t.text     "street_addr"
    t.text     "apartment_no"
    t.text     "city"
    t.text     "zip_code"
    t.text     "state"
    t.text     "country"
    t.integer  "carrier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ssc_banks", force: true do |t|
    t.integer  "profile_id"
    t.integer  "auth_option_id"
    t.text     "ssc"
    t.text     "ct_mask"
    t.text     "auth_value"
    t.datetime "expiry"
    t.integer  "lifetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
