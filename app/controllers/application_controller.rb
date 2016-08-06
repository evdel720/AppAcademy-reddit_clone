class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def login(user)
    user.reset_session_token
    session[:session_token] = user.session_token
  end

  def logout
    current_user.reset_session_token
    session[:session_token] = nil
  end

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def require_log_in
    if current_user.nil?
      flash[:errors] = ["Please log in first."]
      redirect_to new_session_url
    end
  end

  protected
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
