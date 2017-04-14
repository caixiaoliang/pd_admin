class Piano < ActiveRecord::Base
  belongs_to :model
  belongs_to :dealer
  validates_uniqueness_of :device_number
  
  class << self
    def device_number_convert(val)
      # 21和(21)
      val.to_s.gsub(/^21|\(21\)/,'').to_s
    end
    
    def gmc_name_convert(val)
      val.match(/^U1J|\w+(?<=\d)/).to_s
    end
  end
end
