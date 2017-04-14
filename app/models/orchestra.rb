class Orchestra < ActiveRecord::Base
  belongs_to :model
  belongs_to :dealer
  validates_uniqueness_of :device_number

  class << self
    def device_number_convert(val)
      val.to_s.match(/(?<=21)\w+/).to_s
    end
     def gmc_name_convert(val)
      return val
     end
  end
end
