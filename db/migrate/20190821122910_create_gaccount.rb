class CreateGaccount < ActiveRecord::Migration
  def change
    create_table :gaccounts do |t|
        t.string "name",unique: true,null:false
        t.string "pwd",null:false
        t.integer "user_id"
        t.timestamps null: false
    end
  end
end
