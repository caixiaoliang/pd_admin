class Acoustic < ActiveRecord::Base
  belongs_to :model  # 属于某个型号
  belongs_to :dealer
  validates_uniqueness_of :device_number

  class << self
    def device_number_convert(val)
      #21和SER.NO:开头
      val.to_s.gsub(/^(21|SER.NO:)/,'')
    end
    #audio video型号: "NS-777 BLACK //T" 只读 NS-777
    def gmc_name_convert(string)
      string.match(/\w+-\w+/).to_s
    end
  end
end
