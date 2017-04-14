class Api::V1::ProductsInfoController < Api::V1::ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  def index
    type = params[:type]
    @serial_ids = Model.includes(:acoustics).pluck(:serial_id).compact.uniq
    @serials = Serial.where(id: @serial_ids )
  end

  def serials
    @serials = Serial.all.pluck(:name)
  end


  def check_registration_user_info
    @validate = false
    type = params[:type]
    device_number = params[:device_number]
    model_name = params[:model_name]
    @dealer = Dealer.find_by_name(params[:dealer_name])
    if ["pianos","orchestras","acoustics"].include?(type)
      product = @dealer.send(type).find_by_device_number(device_number)
      if product && product.model.name == model_name
        @validate = true
      end
    else
      render json: {success: false,error: "parameters error"}
    end
  end

end