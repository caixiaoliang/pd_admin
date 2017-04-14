module SessionsHelper

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by_id(user_id) 
    elsif (user_id = cookies.signed[:user_id].present?)
      user =  User.find_by_id(user_id)
      if user && user.authenticated?(:remember, cookies.signed[:remember_token])
        log_in(user)
        @current_user = user 
      end
    end
  end

  def remember(user)
    user.set_new_remember_digest
    cookies.permantent.signed[:user_id] = user.id
    cookies.permantent.signed[:remember_token] = user.remember_token
  end

  def forget(user)
    user.clear_remember_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_in(user)
    session[:user_id] = user.id
  end


  def log_out
    # forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in?
    !!current_user
  end

  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get
  end


    
end
