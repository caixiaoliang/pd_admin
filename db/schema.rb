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

ActiveRecord::Schema.define(version: 20190821122910) do

  create_table "acoustics", force: :cascade do |t|
    t.string   "device_number", limit: 255, null: false
    t.integer  "dealer_id",     limit: 4
    t.integer  "model_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "acoustics", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree

  create_table "address_cities", force: :cascade do |t|
    t.integer "code",         limit: 4,   null: false
    t.string  "name",         limit: 255, null: false
    t.integer "provinceCode", limit: 4,   null: false
  end

  create_table "address_provinces", force: :cascade do |t|
    t.integer "code", limit: 4,   null: false
    t.string  "name", limit: 255, null: false
  end

  create_table "address_towns", force: :cascade do |t|
    t.integer "code",     limit: 4,   null: false
    t.string  "name",     limit: 255, null: false
    t.integer "cityCode", limit: 4,   null: false
  end

  create_table "dealers", force: :cascade do |t|
    t.string   "name",            limit: 255, null: false
    t.integer  "address_city_id", limit: 4
    t.string   "nick_name",       limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "dealers", ["name"], name: "index_dealers_on_name", unique: true, using: :btree

  create_table "gaccounts", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "pwd",        limit: 255, null: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "models", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.text     "cover",      limit: 65535
    t.integer  "serial_id",  limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "models", ["name"], name: "index_models_on_name", unique: true, using: :btree

  create_table "orchestras", force: :cascade do |t|
    t.string   "device_number", limit: 255, null: false
    t.integer  "dealer_id",     limit: 4
    t.integer  "model_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "orchestras", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree

  create_table "pgroup", force: :cascade do |t|
    t.string   "vendorId",    limit: 255
    t.string   "productUID",  limit: 255
    t.string   "product_sku", limit: 255
    t.integer  "status",      limit: 8,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pgroup", ["productUID"], name: "puid", unique: true, using: :btree

  create_table "pianos", force: :cascade do |t|
    t.string   "device_number", limit: 255, null: false
    t.integer  "dealer_id",     limit: 4
    t.integer  "model_id",      limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "pianos", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "vendorId",    limit: 255,             null: false
    t.string   "productUID",  limit: 255,             null: false
    t.string   "product_sku", limit: 255,             null: false
    t.integer  "status",      limit: 4,   default: 0
    t.integer  "img_count",   limit: 4,   default: 0
    t.integer  "gaccount_id", limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "serials", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "password_digest", limit: 255,                 null: false
    t.string   "name",            limit: 255
    t.boolean  "admin",                       default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "role",            limit: 255
  end

  add_index "users", ["name"], name: "index_users_on_nickname", unique: true, using: :btree

end
