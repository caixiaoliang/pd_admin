class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
        t.string "vendorId",unique: true,null:false
        t.string "productUID",unique: true,null:false
        t.string "product_sku",unique: true,null:false
        t.integer "status",default: 0
        t.integer "img_count", default: 0
        t.integer "gaccount_id"
        t.timestamps null: false
    end
  end
end
