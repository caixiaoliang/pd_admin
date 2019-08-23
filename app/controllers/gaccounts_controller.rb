class GaccountsController < ApplicationController
  before_filter :check_login
  before_filter :check_limit_gaccount, :only => [:create]

  def new
    @user = Gaccount.new
  end

# 注册
  def create
    name = params[:gaccount][:name]
    @password = params[:gaccount][:pwd]

    @user = Gaccount.new(name: name,pwd: @password, user_id: current_user.id)
    if @user.save
      flash[:message] = "注册成功"
      # respond_to do |format|
      #   format.js
      # end
      redirect_to gaccounts_path
    else
      render "new"
    end
  end

  def edit
    @user = Gaccount.find(params[:id])
  end

  def index
    @users = Gaccount.all
  end

  def update
    @user = Gaccount.find(params[:id])
    if @user.present?
      @password = params[:gaccount][:pwd]

      if @user.update_attributes(name: @user.name, pwd: @password)
        flash[:message] = "更新成功"
        respond_to do |format|
          format.js
        end
      end
    else
      redirect_to gaccounts_path
    end
  end

  def show
    @user = Gaccount.find(params[:id])
  end

  def destroy
    @user = Gaccount.find(params[:id])
    @user.destroy
    redirect_to gaccounts_path
  end

  private 
    def user_params
      params.require(:user).permit(:name)
    end
end
