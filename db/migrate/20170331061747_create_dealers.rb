class CreateDealers < ActiveRecord::Migration
  def change
    create_table :dealers do |t|
      t.string :name,unique: true,null:false
      t.integer :address_city_id
      t.string :nick_name

      t.timestamps null: false
    end
    add_index "dealers", ["name"], name: "index_dealers_on_name", unique: true, using: :btree
  end
end
