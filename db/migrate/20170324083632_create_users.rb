class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "password_digest", limit: 255,   null: false
      t.string   "name",            limit: 255
      t.boolean   "admin",   default: false
      t.timestamps null: false
    end
    add_index "users", ["name"], name: "index_users_on_nickname", unique: true, using: :btree
  end
end
