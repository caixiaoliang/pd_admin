class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

    def check_admin
      unless current_user && current_user.admin?
        redirect_to products_info_index_path
      end
    end
    
    def check_login
      redirect_to login_path  unless logged_in?
    end

    def admin?
      current_user.try(:admin)
    end

    # acoustic piano orchestra
    def role_ability
      current_user.try(:role)
    end

    def get_products(klass=nil)
      val = klass || role_ability
      @products = val.classify.constantize
      return @products.all
    end

    def get_models(klass=nil)
      val = klass || role_ability
      Model.joins(val.to_sym).uniq
    end

    def get_dealers(klass=nil)
      val = klass || role_ability
      Dealer.joins(val.to_sym).uniq
    end

end
