module FileUpload

  class << self
    def tmp_upload_filepath(format)
      Rails.root.join("tmp","upload_file",unique_string+format)
    end

    def unique_string
      Digest::MD5.hexdigest(Time.now.utc.to_i.to_s + '-' + Process.pid.to_s + '-' + ("%04d" % rand(9999)))
    end

    def redis_hash
      @redis_hash ||= Redis::HashKey.new("pd_admin", :marshal => true)
    end
  end

  class ProgressPercentage
    attr_accessor :redis_hash
    # 进度信息默认存在redis中
    def initialize(key=nil)
      @key = key
      @redis_hash = FileUpload.redis_hash
    end

    def progress

      @redis_hash[@key]
    end

    def progress=(hash)
      tmp = progress || {}
      # puts "tmp #{tmp}"
      tmp.merge!(hash)
      # puts "tmpafter #{tmp}"
      @redis_hash[@key] = tmp
    end

    def clear
      FileUpload.redis_hash.delete(@key)
    end

    class << self
      def get_progress_by_key(key)
        FileUpload.redis_hash[key]
      end

      def clear_by_key(key)
        FileUpload.redis_hash.delete(key)
      end
    end
  end

  class Upload
    attr_accessor :format,:name,:tmp_file,:path
    def initialize(opt={})
      @format = opt[:format]
      @name = opt[:name] || unique_string
      @tmp_file = opt[:tmp_file]
      @path = opt[:path] 
    end

    def tmp_upload_filepath
      Rails.root.join("tmp","upload_file",unique_string+format)
    end

    def unique_string
      Digest::MD5.hexdigest(Time.now.utc.to_i.to_s + '-' + Process.pid.to_s + '-' + ("%04d" % rand(9999)))
    end


    def loacl_url
      "#{path}#{name}"+format
    end

    def store_in_local
      File.open(loacl_url, "wb+") do |f|
        f.write(tmp_file.read)
      end
    end
  end


  class ImageUpload < Upload
    # 数据库存储URL,本地存储图片
  end


end