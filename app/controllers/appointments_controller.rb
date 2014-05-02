class AppointmentsController < ApplicationController

  def new
    unless @tutor = Tutor.find_by_id(params[:tutor_id])
      flash[:error] = "Tutor does not exist."
      redirect_to root_url #:back
    end
    @start_time = params[:start_time].to_datetime
  end

  def create
    @appointment = make_appointment
    if @appointment.save
      flash[:success] = "Appointment created successfully."
      redirect_to root_url
    else
      flash[:error] = "Failed to make appointment!"
      render :new
    end
  end

  private

  def make_appointment
    tutor = Tutor.find_by_id(params[:tutor])
    client = Client.find_by_id(params[:client])
    subject = Subject.find_by_id(params[:subject])
    start_time = params[:start_time].to_datetime
    end_time = start_time + params[:length].to_i.minutes
    
    Appointment.new(
      tutor: tutor,
      client: client,
      subject: subject,
      start_time: start_time,
      end_time: end_time,
    )
  end
end
