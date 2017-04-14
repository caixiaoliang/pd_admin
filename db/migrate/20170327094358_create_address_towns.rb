class CreateAddressTowns < ActiveRecord::Migration
  def change
    create_table :address_towns do |t|
      t.integer "code",null: false
      t.string "name",null: false
      t.integer "cityCode",null: false
    end
  end
end
