class DealersController < ApplicationController
  before_action :check_login

  def index
    type = current_user.admin? ? params[:type]||"acoustics" : nil
    @dealers = get_dealers(type).paginate(page: params[:page],per_page: 100)
  end

  def edit

    id = params[:id]
    @dealer = Dealer.find(id)
    @provinces = AddressProvince.all.map{|pro| [pro.name,pro.code]}
    @cities = AddressCity.all.map{|city| [city.name,city.code]}

  end

  def update
    id = params[:id]
    @dealer = Dealer.find(id)
    if dealer_params[:nick_name].present? || dealer_params[:address_city_id]
      if @dealer.update_attributes(dealer_params)
        redirect_to dealers_path
      else
        render :edit
      end
    else
      render :edit
    end
  end

  def destroy
    id = params[:id]
    @dealer = Dealer.find(id)
    @dealer.destroy
    redirect_to :index
  end
  
  private
    def dealer_params
      params.require(:dealer).permit(:nick_name,:address_city_id)
    end
end
