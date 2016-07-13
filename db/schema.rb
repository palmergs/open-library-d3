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

ActiveRecord::Schema.define(version: 20160713123219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "ident",         limit: 15
    t.string   "name",                                  null: false
    t.string   "personal_name"
    t.integer  "birth_date"
    t.integer  "death_date"
    t.string   "death_place"
    t.text     "description",              default: "", null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "authors", ["ident"], name: "index_authors_on_ident", using: :btree

  create_table "edition_publishers", force: :cascade do |t|
    t.string   "name",       limit: 63, null: false
    t.integer  "edition_id",            null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "edition_publishers", ["edition_id"], name: "index_edition_publishers_on_edition_id", using: :btree

  create_table "editions", force: :cascade do |t|
    t.integer  "work_id",                                          null: false
    t.integer  "edition_publishers_count",            default: 0,  null: false
    t.string   "ident",                    limit: 15
    t.string   "title",                                            null: false
    t.string   "subtitle"
    t.string   "lcc",                      limit: 15
    t.integer  "pages"
    t.integer  "copyright_date"
    t.integer  "publish_date"
    t.integer  "publish_country"
    t.string   "format"
    t.string   "series"
    t.text     "first_sentence"
    t.text     "description",                         default: "", null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "editions", ["ident"], name: "index_editions_on_ident", using: :btree
  add_index "editions", ["lcc"], name: "index_editions_on_lcc", using: :btree
  add_index "editions", ["work_id"], name: "index_editions_on_work_id", using: :btree

  create_table "external_links", force: :cascade do |t|
    t.integer  "linkable_id",              null: false
    t.string   "linkable_type", limit: 63, null: false
    t.string   "name",                     null: false
    t.string   "value",                    null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "external_links", ["linkable_id", "linkable_type"], name: "index_external_links_on_linkable_id_and_linkable_type", using: :btree

  create_table "subject_tags", force: :cascade do |t|
    t.integer  "taggable_id",              null: false
    t.string   "taggable_type", limit: 63, null: false
    t.string   "name",                     null: false
    t.string   "value",                    null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "subject_tags", ["taggable_id", "taggable_type"], name: "index_subject_tags_on_taggable_id_and_taggable_type", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string  "token_type", limit: 20,             null: false
    t.integer "category",                          null: false
    t.integer "year",                              null: false
    t.string  "token",      limit: 60,             null: false
    t.integer "count",                 default: 0, null: false
  end

  add_index "tokens", ["token"], name: "index_tokens_on_token", using: :btree
  add_index "tokens", ["token_type", "category", "year"], name: "index_tokens_on_token_type_and_category_and_year", using: :btree
  add_index "tokens", ["year"], name: "index_tokens_on_year", using: :btree

  create_table "work_authors", force: :cascade do |t|
    t.integer "work_id",                                 null: false
    t.integer "author_id",                               null: false
    t.integer "rel_order",            default: 0,        null: false
    t.string  "role",      limit: 24, default: "author", null: false
  end

  add_index "work_authors", ["author_id"], name: "index_work_authors_on_author_id", using: :btree
  add_index "work_authors", ["work_id"], name: "index_work_authors_on_work_id", using: :btree

  create_table "works", force: :cascade do |t|
    t.string   "ident",          limit: 15
    t.string   "title",                                  null: false
    t.string   "subtitle"
    t.string   "lcc",            limit: 15
    t.integer  "editions_count",            default: 0,  null: false
    t.integer  "publish_date"
    t.text     "sentence"
    t.text     "description",               default: "", null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "works", ["ident"], name: "index_works_on_ident", using: :btree
  add_index "works", ["lcc"], name: "index_works_on_lcc", using: :btree
  add_index "works", ["publish_date"], name: "index_works_on_publish_date", using: :btree

end
