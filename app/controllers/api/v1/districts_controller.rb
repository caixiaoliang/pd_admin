class Api::V1::DistrictsController < Api::V1::ApplicationController
  respond_to :json
  protect_from_forgery  except: :by_dealer
  skip_before_filter :verify_authenticity_token, :only => [:by_dealer]

  def index
    @provinces = AddressProvince.all
    # @cities = AddressCity.all
  end

  # 经销商所在的省市
  def by_dealer
    @province_ids = AddressCity.joins(:dealers).pluck(:provinceCode).uniq.compact
    @provinces = AddressProvince.where(code: @province_ids) if @province_ids.present?
  end

  def cities
    @cities = AddressCity.all
  end

  def provinces
    @provinces = AddressProvince.all
  end

  def cities_by_province
    province_code = params[:provinceCode]    
    @province = AddressProvince.find_by_code(province_code)
    @cities  = @province.cities
  end

  def province_by_cities
    city_code = params[:cityCode]
    @city = AddressCity.find_by_code(city_code)
    @province = @city.province
  end

end