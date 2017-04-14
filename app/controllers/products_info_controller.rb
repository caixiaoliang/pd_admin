class ProductsInfoController < ApplicationController
  # respond_to :html, :js
  before_action :check_login
  def index
    type = current_user.admin? ? params[:type]||"acoustics" : nil
    @products = get_products(type).paginate(page: params[:page],per_page: 100)
  end

  def upload
    # 初始化存储进度信息的redis hash
    @csv_file = FileUpload::Upload.new(format: ".csv",tmp_file: params[:file].tempfile, 
        path: Enums.loacl_product_csv_ptah)
    @csv_file.store_in_local
    lines_count = File.open(@csv_file.loacl_url){|f| f.readlines.size}
    @key = FileUpload.unique_string
    UploadWorker.perform_async(@csv_file.loacl_url,lines_count,@key,current_user.role)
  end

  def upload_progress
    key = params[:key]
    completed = false
    progress = FileUpload::ProgressPercentage.get_progress_by_key(key)
    data = progress
    if progress && (progress[:total_count].to_i) == (progress[:completed_count].to_i+1)
      FileUpload::ProgressPercentage.clear_by_key(key)
      completed = true
    end
    render json: { success: true, code: 200, count: data,completed: completed }

  end

end
