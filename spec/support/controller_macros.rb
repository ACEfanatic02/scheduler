module ControllerMacros

  def login_as(user)
    session[:user_id] = user
  end
end