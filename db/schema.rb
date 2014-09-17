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

ActiveRecord::Schema.define(version: 20140915132851) do

  create_table "books", force: true do |t|
    t.string   "douban_book_id"
    t.string   "user_id"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "authors"
    t.string   "image_href"
    t.string   "price"
    t.string   "publisher"
    t.string   "publish_date"
    t.text     "author_info"
    t.text     "description"
    t.string   "authorInfo"
  end

  create_table "groups", force: true do |t|
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.integer  "group_id"
  end

end
