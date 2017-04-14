class SessionsController < ApplicationController
  def new
    redirect_to(root_url) if current_user
    @user = User.new
  end

  def create
    unless user_params[:name].present?
      flash[:danger] = "帐号不能为空"
      return redirect_to login_url
    end
    @user = User.find_by_name(user_params[:name])

    if @user && @user.authenticate(user_params[:password])
      log_in(@user)
      flash[:success] = "登录成功"
      # params[:user][:remember_me] == "1" ? remember(@user) : forget(@user) 
      redirect_to root_url
    else
      if @user && !@user.authenticate(user_params[:password])
        @user.errors.add(:password, "密码错误")
      else
        @user.errors.add(:name,"帐户不存在")
      end
      render "new"
    end
  end

  def destroy
    log_out
    flash[:message] = "退出成功"
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(:account,:_rucaptcha,:name,:email,:phone,:password,:password_confirmation,:verify_code)
    end
end
