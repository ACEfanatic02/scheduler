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

    @appointment = Appointment.new(client: @client, 
                                   tutor: @tutor, 
                                   subject: @subject, 
                                   start_time: Time.now.beginning_of_hour, 
                                   end_time: Time.now.end_of_hour)
  end

  subject { @appointment }

  it { should respond_to(:client) }
  it { should respond_to(:tutor) }
  it { should respond_to(:subject) }

  it { should respond_to(:start_time) }
  it { should respond_to(:length) }

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

    describe "with no start time" do
      before { @appointment.start_time = nil }
      it { should_not be_valid }
    end

    describe "with no end time" do
      before { @appointment.end_time = nil }
      it { should_not be_valid }
    end

    describe "with subject tutor does not teach" do
      before do 
        @appointment.subject = Subject.new(course_number: "ENG111", 
                                           course_name: "English Composition I") 
      end
      it { should_not be_valid }
    end

    describe "with negative time range" do
      before do
        @appointment.end_time = @appointment.start_time - 1.minutes;
      end

      it { should_not be_valid }
    end

    describe "with equal start and end times" do
      before do
        @appointment.end_time = @appointment.start_time
      end

      it { should_not be_valid }
    end

    describe "when overlapping existing appointment time for same tutor" do
      before do
        other = @appointment.dup
        other.start_time += 15.minutes
        other.end_time += 15.minutes
        other.save!
      end

      it { should_not be_valid }
    end

    describe "with adjacent appointments for same tutor" do
      before do
        before = @appointment.dup
        before.start_time = @appointment.start_time - 15.minutes
        before.end_time = @appointment.start_time
        before.save!

        after = @appointment.dup
        after.start_time = @appointment.end_time
        after.end_time = @appointment.end_time + 15.minutes
        after.save!
      end

      it { should be_valid }
    end

    describe "with overlapping appointment for different tutor" do
      before do
        other = @appointment.dup
        other.tutor = Tutor.create!
        other.tutor.subjects << @subject
        other.save!
      end

      it { should be_valid }
    end
  end
end
