require 'parallel'
require 'smarter_csv'

namespace :import  do
  desc "importer csv  "
  task :importer_products_info => :environment do
    #audio video机号: 录入时去除前缀21,SER.NO:
    def device_number_convert(string)
      string.match(/(?<=21|SER.NO:)\w+/).to_s
    end
    #audio video型号: "NS-777 BLACK //T" 只读 NS-777
    def gmc_name_convert(string)
      string.match(/\w+-\w+/).to_s
    end

    def worker(array_of_hashes)
      array_of_hashes.each do |hash|
        hash.reject!{|k,v| !["out_da","dealer_name","gmc_name"].include?(k.to_s)}

        dealer_name = hash[:dealer_name] #经销商
        if hash[:out_da].present? && hash[:gmc_name].present?
          device_number = device_number_convert(hash[:out_da])   #机号
          gmc_name = gmc_name_convert(hash[:gmc_name]) #型号
          model = Model.find_or_create_by(name: gmc_name)
          Acoustic.find_or_create_by(device_number: device_number,dealer: dealer_name,model_id: model.id)
        end
      end
    end

    chunks = SmarterCSV.process('/Users/xiaoliang/Desktop/AV2.CSV', chunk_size: 1000)
    # chunks.each do |chunk|
    #   worker(chunk)
    # end
    Parallel.map(chunks) do |chunk|
      worker(chunk)
    end
  end
end