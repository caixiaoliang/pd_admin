class AddIndexToInstruments < ActiveRecord::Migration
  def change
    add_index "pianos", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree
    add_index "orchestras", ["device_number"], name: "index_models_on_device_number", unique: true, using: :btree
  end
end
