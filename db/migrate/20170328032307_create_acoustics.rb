class CreateAcoustics < ActiveRecord::Migration
  def change
    create_table :acoustics do |t|
      t.string "device_number" ,unique: true,null:false
      t.integer "dealer_id" 
      t.integer "model_id"
      t.timestamps null: false
    end
    add_index "acoustics", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree
  end
end
