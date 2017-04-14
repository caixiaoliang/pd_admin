class AddressProvince < ActiveRecord::Base
  has_many :cities,class_name: "AddressCity",foreign_key: "provinceCode",primary_key: "code"


  def dealer_cities
    self.cities.select{|city| city.dealers.present?}
  end
end
