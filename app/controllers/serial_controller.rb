class SerialController < ApplicationController
  before_action :check_login

  def index
    type = admin? ? (params[:type]||"acoustics") : nil
    @models = get_models(type).paginate(page: params[:page],per_page: 100)
  end

  def edit
    @model = Model.find(params[:id])
    @tags_options = Tag.all.map{|tag| [tag.name,tag.id]}
  end

  def update
    model_params={}
    @model = Model.find(params[:id])
    @serial = Serial.find_or_create_by(name: params[:serial_name])
    model_params[:serial_id] = @serial.id if @serial
    model_params[:tag_id] = params[:tag_id]  if params[:tag_id]

    if params[:file]
      @image = FileUpload::ImageUpload.new(format: ".png",tmp_file: params[:file].tempfile, 
        path: Enums.loacl_image_path)
      @image.store_in_local
      model_params[:cover] = @image.name
    end

    if @model.update_attributes(model_params)
      redirect_to serial_index_path
    else
      render :edit
    end
  end

end
