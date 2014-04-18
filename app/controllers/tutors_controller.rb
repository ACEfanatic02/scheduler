class TutorsController < ApplicationController
  before_action :require_admin, except: [:index, :show]

  def index
    @tutors = Tutor.all
  end

  def show
    @tutor = Tutor.find(params[:id])
  end

  def create
    user = User.find_by_id(params[:user_id])
    if user.tutor?
      flash[:notice] = "#{user.username} is already a tutor."
    else
      tutor = user.build_tutor
      add_subjects(tutor)
      tutor.save!
      flash[:success] = "#{user.username} is now a tutor."
    end
    redirect_to users_path(user)
  end

  def update
    if tutor = Tutor.find_by_id(params[:id])
      add_subjects(tutor)
      redirect_to users_path(tutor.user)
    else
      flash[:error] = "Tutor does not exist."
      redirect_to root_url # temporarily redirect to root
    end
  end

  private

  def add_subjects(tutor)
    params[:subjects] && params[:subjects].each do |subject|
      unless tutor.subjects.exists?(subject)
        tutor.subjects << Subject.find(subject)
      end
    end
  end
end
