module Enums
  class << self

    Account_Types = {pianos: "钢琴",orchestras: "管乐",acoustics: "音响"}.freeze
    
    Local_Model_Image_Path =  Rails.root.join("app/assets/images/model_covers/")
    Loacl_Product_CSV_Ptah = Rails.root.join("groupon/upload_file/")
    def account_type
      Account_Types
    end
    
    def loacl_image_path
      Local_Model_Image_Path
    end

    def loacl_product_csv_ptah
      Loacl_Product_CSV_Ptah
    end

  end
end