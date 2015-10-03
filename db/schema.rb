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

ActiveRecord::Schema.define(version: 20151003190914) do

  create_table "elements", force: true do |t|
    t.string   "element_name"
    t.string   "element_type"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_id"
  end

  add_index "elements", ["work_id"], name: "index_elements_on_work_id"

  create_table "operators", force: true do |t|
    t.text     "name"
    t.text     "view_attributes"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_id"
  end

  add_index "operators", ["work_id"], name: "index_operators_on_work_id"

  create_table "texts", force: true do |t|
    t.integer  "sequence"
    t.text     "content_text"
    t.string   "color_override"
    t.boolean  "visibility"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "operator_note"
    t.integer  "work_id"
    t.integer  "element_id"
  end

  add_index "texts", ["element_id"], name: "index_texts_on_element_id"
  add_index "texts", ["work_id"], name: "index_texts_on_work_id"

  create_table "venues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "works", force: true do |t|
    t.string   "work_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
    t.integer  "characters_per_line"
    t.integer  "venue_id"
  end

  add_index "works", ["venue_id"], name: "index_works_on_venue_id"

end
