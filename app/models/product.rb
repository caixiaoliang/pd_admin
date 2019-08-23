class Product < ActiveRecord::Base
  belongs_to :gaccount

  # validates_uniqueness_of :device_number
  
  # class << self
  #   def device_number_convert(val)
  #     # 21和(21)
  #     val.to_s.gsub(/^21|\(21\)/,'').to_s
  #   end
    
  #   def gmc_name_convert(val)
  #     val.match(/^U1J|\w+(?<=\d)/).to_s
  #   end
  # end
  class << self
    def upload(path)
      puts "#{path}"
      # Thread.new do
      system("python groupon/src/test.py")
      # end
      
      # exec("python groupon/groupService.py #{path}")
    end
  end
end
