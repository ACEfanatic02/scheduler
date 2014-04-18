class TutorsController < ApplicationController
  before_action :require_admin

  def create
    user = User.find_by_id(params[:user_id])
    if user.tutor?
      flash[:notice] = "#{user.username} is already a tutor."
    else
      tutor = user.build_tutor
      tutor.save!
      flash[:success] = "#{user.username} is now a tutor."
    end
    redirect_to users_path(user)
  end
end
