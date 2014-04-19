class ScheduleController < ApplicationController

  def index
    @start_date = params[:start_date].to_datetime
    @end_date = @start_date + 5.days
    @tutors = Tutor.all
  end
end
