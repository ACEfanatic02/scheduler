class ScheduleController < ApplicationController

  def index
    start_date = params[:start_date].to_datetime

    @days = [0, 1, 2, 3, 4].map { |offset| start_date.advance(days: offset) }
    @tutors = Tutor.all
  end
end
