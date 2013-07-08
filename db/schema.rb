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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130708190351) do

  create_table "batting_projections", :force => true do |t|
    t.string   "company"
    t.integer  "player_id"
    t.integer  "gp"
    t.integer  "pa"
    t.float    "ab"
    t.float    "bb"
    t.float    "hbp"
    t.float    "k"
    t.float    "hits"
    t.float    "singles"
    t.float    "doubles"
    t.float    "triples"
    t.float    "hr"
    t.float    "ba"
    t.float    "obp"
    t.float    "slg"
    t.float    "ops"
    t.float    "sb"
    t.float    "cs"
    t.float    "sbn"
    t.float    "r"
    t.float    "rbi"
    t.float    "ppa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "batting_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "gp"
    t.integer  "pa"
    t.float    "ab"
    t.float    "bb"
    t.float    "hbp"
    t.float    "k"
    t.float    "hits"
    t.float    "singles"
    t.float    "doubles"
    t.float    "triples"
    t.float    "hr"
    t.float    "ba"
    t.float    "obp"
    t.float    "slg"
    t.float    "ops"
    t.float    "sb"
    t.float    "cs"
    t.float    "sbn"
    t.float    "r"
    t.float    "rbi"
    t.float    "ppa"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "leagues", :force => true do |t|
    t.integer  "user_id"
    t.integer  "num_c"
    t.integer  "num_1b"
    t.integer  "num_2b"
    t.integer  "num_3b"
    t.integer  "num_ss"
    t.integer  "num_lf"
    t.integer  "num_cf"
    t.integer  "num_rf"
    t.integer  "num_dh"
    t.integer  "num_teams"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "player_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "name"
    t.integer  "age"
    t.integer  "pos"
    t.integer  "team_id"
    t.boolean  "batsman"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "teams", :force => true do |t|
    t.string "name"
    t.string "circuit"
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
