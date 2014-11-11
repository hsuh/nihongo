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

ActiveRecord::Schema.define(version: 20141102185543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
  end

  create_table "notes", force: true do |t|
    t.text     "kanji"
    t.text     "kana"
    t.text     "phrase"
    t.text     "meaning"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.text     "template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "answer_id"
    t.integer  "stack_id"
  end

  add_index "questions", ["stack_id"], name: "index_questions_on_stack_id", using: :btree

  create_table "stacks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "tests", force: true do |t|
    t.integer  "testable_id"
    t.integer  "stack_id"
    t.integer  "right_count"
    t.integer  "wrong_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "testable_type"
  end

end
