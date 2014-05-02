class AppointmentsController < ApplicationController

  before_action :require_login

  def new
    unless @tutor = Tutor.find_by_id(params[:tutor_id])
      flash[:error] = "Tutor does not exist."
      redirect_to root_url #:back
    end
    @start_time = params[:start_time].to_datetime
    @client = current_user.client
  end

  def create
    @appointment = make_appointment
    if @appointment.save
      flash[:success] = "Appointment created successfully."
      redirect_to root_url
    else
      flash[:error] = "Failed to make appointment!"
      redirect_to appointments_path(params[:tutor_id], params[:start_time])
    end
  end

  private

  def make_appointment
    tutor = Tutor.find_by_id(params[:tutor_id])
    client = Client.find_by_id(params[:client_id])
    subject = Subject.find_by_id(params[:subject])
    start_time = params[:start_time].to_datetime
    length = params[:length].empty? ? 15 : params[:length].to_i
    end_time = start_time + length.minutes
    
    Appointment.new(
      tutor: tutor,
      client: client,
      subject: subject,
      start_time: start_time,
      end_time: end_time,
    )
  end
end
