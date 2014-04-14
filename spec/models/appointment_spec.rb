require 'spec_helper'

describe Appointment do

  before do
    client_user = User.new(username: 'client', email: 'client@example.com',
                           password: 'password', password_confirmation: 'password')
    tutor_user = User.new(username: 'tutor', email: 'tutor@example.com',
                          password: 'password', password_confirmation: 'password')
    client_user.save!
    tutor_user.save!

    @client = client_user.build_client
    @tutor = tutor_user.build_tutor

    @client.save!
    @tutor.save!

    @subject = Subject.new(course_number: "CSC200", course_name: "Intro to Computer Science")

    @tutor.subjects << @subject

    @appointment = Appointment.new(client: @client, tutor: @tutor, subject: @subject)
  end

  subject { @appointment }

  it { should respond_to(:client) }
  it { should respond_to(:tutor) }
  it { should respond_to(:subject) }

  it { should be_valid }

  describe "validation" do

    describe "with no tutor" do
      before { @appointment.tutor = nil }
      it { should_not be_valid }
    end

    describe "with no client" do
      before { @appointment.client = nil }
      it { should_not be_valid }
    end

    describe "with no subject" do
      before { @appointment.subject = nil }
      it { should_not be_valid }
    end

    describe "with subject tutor does not teach" do
      before do 
        @appointment.subject = Subject.new(course_number: "ENG111", 
                                           course_name: "English Composition I") 
      end
      it { should_not be_valid }
    end
  end
end
