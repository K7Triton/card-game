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

ActiveRecord::Schema.define(version: 20160811072714) do

  create_table "cards", force: :cascade do |t|
    t.integer "value"
    t.string  "card_type"
    t.string  "image"
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "player_1"
    t.integer  "player_2"
    t.integer  "player_3"
    t.integer  "player_4"
    t.integer  "player_1_id"
    t.integer  "player_2_id"
    t.integer  "player_3_id"
    t.integer  "player_4_id"
    t.integer  "player_1_cards"
    t.integer  "player_2_cards"
    t.integer  "player_3_cards"
    t.integer  "player_4_cards"
    t.integer  "bank"
    t.integer  "otboi"
  end

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end