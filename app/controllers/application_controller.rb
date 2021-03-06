class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  def index
    if current_user
      redirect_to schedule_path(start_date: Time.now.beginning_of_week)
    else
      render '/index'
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def stash_location(location = nil)
    session[:return_to] = location || request.fullpath
  end

  def pop_location(default = root_url)
    session[:return_to] || root_url
  end

  def require_admin
    unless current_user && current_user.admin?
      flash[:error] = "This action requires administrative privileges."
      redirect_to root_url
      false
    end
  end

  def require_login
    unless current_user
      flash[:error] = "This action requires you to login."
      stash_location
      redirect_to login_url
      false
    end
  end

  def require_user_login_or_admin
    unless current_user && (current_user.id == params[:id].to_i || current_user.admin?)
      flash[:error] = "This action requires administrative privileges."
      redirect_to root_url
      false
    end
  end
end
