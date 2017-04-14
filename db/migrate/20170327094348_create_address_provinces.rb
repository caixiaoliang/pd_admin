class CreateAddressProvinces < ActiveRecord::Migration
  def change
    create_table :address_provinces do |t|
      t.integer "code", null: false
      t.string "name",null: false
    end
  end
end
