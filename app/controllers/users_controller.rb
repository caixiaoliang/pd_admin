class UsersController < ApplicationController
  before_filter :check_login,:check_admin

  def new
    @user = User.new
  end

# 注册
  def create
    name = params[:user][:name]
    @password = User.generate_password
    password_digest = User.digest(@password)
    @user = User.new(name: name,password_digest: password_digest,role: params[:role])
    if @user.save
      flash[:message] = "注册成功"
      respond_to do |format|
        format.js
      end
    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def update
    @user = User.find(params[:id])
    if @user.present?
      @password = User.generate_password
      password_digest = User.digest(@password)
      if @user.update_attributes(name: @user.name, password_digest: password_digest)
        flash[:message] = "更新成功"
        respond_to do |format|
          format.js
        end
      end
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_path
  end

  private 
    def user_params
      params.require(:user).permit(:name)
    end
end
