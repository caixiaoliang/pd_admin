class CreateModels < ActiveRecord::Migration
  def change
    # 型号
    create_table :models do |t|
      t.string "name",unique: true,null:false
      t.text "cover"
      t.integer "serial_id"
      t.integer "tag_id"
      t.timestamps null: false
    end
    add_index "models", ["name"], name: "index_models_on_name", unique: true, using: :btree
  end
end
