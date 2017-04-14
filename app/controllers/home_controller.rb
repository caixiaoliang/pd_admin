class HomeController < ApplicationController
  before_action :check_login
  def index
    @users = User.all 
  end
end
