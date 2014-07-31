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

ActiveRecord::Schema.define(version: 20140731012900) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "type",       null: false
    t.integer  "type_id",    null: false
    t.string   "name",       null: false
  end

  add_index "items", ["type_id"], name: "index_items_on_type_id", unique: true, using: :btree

  create_table "order_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "order_id",   null: false
    t.integer  "item_id",    null: false
    t.integer  "quantity",   null: false
  end

  add_index "order_items", ["item_id"], name: "index_order_items_on_item_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "character_name", null: false
    t.integer  "item_id",        null: false
  end

  add_index "orders", ["item_id"], name: "index_orders_on_item_id", using: :btree

  add_foreign_key "order_items", "items", name: "order_items_item_id_fk"
  add_foreign_key "order_items", "orders", name: "order_items_order_id_fk"

  add_foreign_key "orders", "items", name: "orders_item_id_fk"

end
