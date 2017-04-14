class AddressTown < ActiveRecord::Base
  belongs_to :city,class_name: "AddressCity",foreign_key: "cityCode",primary_key: "code"
end
