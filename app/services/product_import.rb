class ProductImport

  attr_reader :progress_percentage, :file,:role
  def initialize(file,progress_key=nil,role)
    @progress_percentage = FileUpload::ProgressPercentage.new(key = progress_key)
    @file = file
    @role = role
  end

  def work(&blcok)
    completed_count = 0
    chunks = SmarterCSV.process(self.file, chunk_size: 1000)
    chunks.each do |chunk|
      blcok.call(chunk)
      completed_count += chunk.count
      self.progress_percentage.progress = {completed_count: completed_count}
      puts "completed_count:#{completed_count} redis#{self.progress_percentage.progress}"
    end
    File.delete(self.file)
  end

  def after_import
    case self.role
    when  'pianos'
      generate_tags("pianos")
    end  
  end


  def generate_tags(product)
    models = Model.joins(product.to_sym).uniq
    models.each do |model|
      begin
        aleph = model.pianos.first.device_number[0]

        case aleph
        when "J"
          tag = Tag.find_or_create_by!(name: "印尼产");
        when "H"
          tag = Tag.find_or_create_by!(name: "中国产");
        when "CH"
          tag = Tag.find_or_create_by!(name: "中国产");
        else
          if aleph =~ /^\d/
            tag = Tag.find_or_create_by!(name: "日本产");
          end
        end 
        model.update_attribute(:tag_id, tag.id) if tag
      rescue Exception => e
        puts e
      end
    end
  end

  def test_upload
    (1..10).each do |num|
      progress[:completed_count] += num
      puts num
      redis_hash[:progress] = progress
    end
  end

  def speed_up_worker(chunks, &logic)
    Parallel.map(chunks,in_threads: 8) do |chunk|
      begin
        logic.call
      rescue Exception => e
        raise Parallel::Kill
      end
    end
  end


  class << self
    def product_data_parse(klass_name,opt={})
      return ->(array_of_hashes){
        klass = klass_name.constantize

        dk = opt[:device_number_hash_k].to_sym
        mk = opt[:model_name_hash_k].to_sym
        dnk = opt[:dealer_name_hash_k].to_sym


        array_of_hashes.each do |hash|
          hash.reject!{|k,v| ![dk,mk,dnk].include?(k)}

          if hash[dk] && hash[mk] && hash[dnk]
            device_number = klass.device_number_convert(hash[dk])
            model_name = klass.gmc_name_convert(hash[mk])
            dealer_name = hash[dnk]

            begin
              dealer = Dealer.find_or_create_by!(name: dealer_name)
              model = Model.find_or_create_by!(name: model_name)
              if model && dealer && device_number.present?
                klass.find_or_create_by!(device_number: device_number) do |product|
                  product.model_id = model.id
                  product.dealer_id = dealer.id
                end
              end
            rescue ActiveRecord::RecordNotUnique => e
              puts e
            end
          end
        end
      }
    end

    def orchestras_data_parse
      product_data_parse("Orchestra",device_number_hash_k: "机号",model_name_hash_k: "型号",dealer_name_hash_k: "收货单位")
    end

    def pianos_data_parse
      product_data_parse("Piano",device_number_hash_k: "机号",model_name_hash_k: "型号",dealer_name_hash_k: "收货单位")
    end

    def acoustics_data_parse
      product_data_parse("Acoustic",device_number_hash_k: "out_da",model_name_hash_k: "gmc_name",dealer_name_hash_k: "dealer_name")
    end

    def data_parse_by_role(role)
      return unless ["orchestras","acoustics","pianos"].include?(role)
      send("#{role}_data_parse")
    end
  end
end