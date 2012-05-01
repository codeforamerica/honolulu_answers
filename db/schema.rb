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

ActiveRecord::Schema.define(:version => 20120430232605) do

  create_table "articles", :force => true do |t|
    t.datetime "updated"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "category"
    t.integer  "content_type"
    t.text     "preview"
    t.integer  "contact_id"
    t.text     "tags"
    t.string   "service_url"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.string   "subname"
    t.string   "number"
    t.string   "url"
    t.string   "address"
    t.string   "department"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
