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

ActiveRecord::Schema.define(version: 20150619200126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cabinets", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cabinets", ["user_id"], name: "index_cabinets_on_user_id", using: :btree

  create_table "medicines", force: :cascade do |t|
    t.integer  "cabinet_id"
    t.string   "set_id",     default: "", null: false
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medicines", ["cabinet_id"], name: "index_medicines_on_cabinet_id", using: :btree
  add_index "medicines", ["name"], name: "index_medicines_on_name", using: :btree
  add_index "medicines", ["set_id"], name: "index_medicines_on_set_id", using: :btree

  create_table "searchable_medicines", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "searchable_medicines", ["name"], name: "index_searchable_medicines_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "cabinets", "users"
  add_foreign_key "medicines", "cabinets"
end
