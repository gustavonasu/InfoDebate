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

ActiveRecord::Schema.define(:version => 20130219014547) do

  create_table "comments", :force => true do |t|
    t.string   "body",       :limit => 4000
    t.integer  "thread_id",                                :null => false
    t.integer  "user_id",                                  :null => false
    t.integer  "status",                                   :null => false
    t.integer  "dislike",                   :default => 0
    t.integer  "like",                      :default => 0
    t.integer  "parent_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "comments", ["parent_id"], :name => "index_comments_on_parent_id"
  add_index "comments", ["thread_id"], :name => "index_comments_on_thread_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "complaints", :force => true do |t|
    t.integer  "comment_id"
    t.string   "body",       :limit => 4000
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "complaints", ["comment_id"], :name => "index_complaints_on_comment_id"
  add_index "complaints", ["user_id"], :name => "index_complaints_on_user_id"

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
