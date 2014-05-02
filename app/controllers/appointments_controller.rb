class AppointmentsController < ApplicationController

  def new
    unless @tutor = Tutor.find_by_id(params[:tutor_id])
      flash[:error] = "Tutor does not exist."
      redirect_to root_url #:back
    end
    @start_time = params[:start_time].to_datetime
  end
end
