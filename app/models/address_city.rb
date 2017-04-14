class AddressCity < ActiveRecord::Base
  belongs_to :province,class_name: "AddressProvince", primary_key: "code",foreign_key: "provinceCode"
  has_many :towns,class_name: "AddressTown",primary_key: "code",foreign_key: "cityCode"
  has_many :dealers,primary_key: "code"
end
