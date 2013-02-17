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

ActiveRecord::Schema.define(:version => 20130217182904) do

  create_table "forum_threads", :force => true do |t|
    t.string   "name",        :limit => 100, :null => false
    t.string   "description"
    t.string   "url",         :limit => 500
    t.integer  "status",                     :null => false
    t.integer  "content_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "forum_id",                   :null => false
  end

  add_index "forum_threads", ["forum_id"], :name => "index_forum_threads_on_forum_id"

  create_table "forums", :force => true do |t|
    t.string   "name",        :limit => 100, :null => false
    t.string   "description"
    t.integer  "status",                     :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",               :limit => 100, :null => false
    t.string   "username",           :limit => 30,  :null => false
    t.string   "email",                             :null => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "status"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["username"], :name => "index_users_on_username"

end
