class CreateAddressCities < ActiveRecord::Migration
  def change
    create_table :address_cities do |t|
      t.integer "code",null: false
      t.string  "name",null: false
      t.integer "provinceCode",null: false
    end
  end
end
