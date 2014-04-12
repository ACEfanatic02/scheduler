class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    flash[:success] = "Testing success flash!"
    flash[:notice] = "Testing notice flash!"
    flash[:error] = "Testing error flash!"
    render '/index'
  end
end
