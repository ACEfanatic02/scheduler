class ScheduleController < ApplicationController

  def index
    @start_date = Time.new(params[:start_date])
    @end_date = @start_date + 5.days
  end
end
