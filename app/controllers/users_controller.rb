class UsersController < ApplicationController

  before_action :require_admin, except: [:new, :create]

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User successfully created!"
      redirect_to root_url
      session[:user_id] = @user.id
    else
      render 'new'
    end
  end

  def destroy
    User.delete(params[:id])
    flash[:success] = "User successfully deleted!"
    redirect_to root_url
  end

  private

    def user_params
      {
        username: params[:username],
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      }
    end
end
