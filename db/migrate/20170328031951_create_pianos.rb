class CreatePianos < ActiveRecord::Migration
  def change
    create_table :pianos do |t|
      t.string "device_number",unique: true,null:false
      t.integer "dealer_id" 
      t.integer "model_id"
      t.timestamps null: false
    end
  end
end
