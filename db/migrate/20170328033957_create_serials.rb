class CreateSerials < ActiveRecord::Migration
  def change
    # 系列名
    create_table :serials do |t|
      t.string "name",unique: true,null:false
      t.timestamps null: false
    end
  end
end
