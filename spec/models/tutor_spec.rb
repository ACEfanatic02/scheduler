require 'spec_helper'

describe Tutor do

  before do
    @user = User.new(username: "test1234", email: "test1234@example.com",
                     password: "foobarbaz", password_confirmation: "foobarbaz")
    @user.save!
    @tutor = @user.build_tutor
  end

  subject { @tutor }

  it { should respond_to(:user) }
  it { should respond_to(:appointments) }
  it { should respond_to(:clients) }
  it { should respond_to(:subjects) }

  it { should be_valid }

  it "can access its user instance" do
    expect(@tutor.user).to eq(@user)
  end

  it "can access and modify its subjects" do
    @tutor.save!
    @tutor.subjects.create(course_number: "CSC200", course_name: "Intro to Computer Science")
    expect(@tutor.subjects.count).to eq(1)
  end

  describe 'schedule for day' do
    before do
      @today = Time.now.midnight
      @tutor.save!
    end

    describe "with an appointment" do
      before do
        client = User.create!(username: 'client', email: 'client@example.com', 
          password: 'password', password_confirmation: 'password').build_client
        client.save!
        csc200 = @tutor.subjects.create!(course_number: 'CSC200', course_name: 'Intro to Computer Science')
        @tutor.appointments.create!(client: client, subject: csc200, 
          start_time: @today.change(hour: 9, min: 0), end_time: @today.change(hour: 9, min: 30))
      end

      it "should list appointment" do
        schedule = @tutor.schedule_for(@today, 9, 18)
        expect(schedule).to_not be_nil
        expect(schedule.first[:type]).to eq(:appointment)
        expect(schedule.first[:contents]).to_not be_nil
      end

      it "appointment should have a length of 2" do
        schedule = @tutor.schedule_for(@today, 9, 18)
        expect(schedule.first[:length]).to eq(2)
      end

      it "should contain one cell length per 15 minutes" do
        schedule = @tutor.schedule_for(@today, 9, 18)
        expected_cells = (18 - 9) * 4
        expect(
          schedule.inject(0) { |sum, block| sum += block[:length] } 
        ).to eq(expected_cells)
      end
    end

    describe "without an appointment" do

      it "should contain only open blocks" do
        @tutor.schedule_for(@today, 9, 18).each do |block|
          expect(block[:type]).to eq(:open)
        end
      end

      it "should contain one cell length per 15 minutes" do
        schedule = @tutor.schedule_for(@today, 9, 18)
        expected_cells = (18 - 9) * 4
        expect(
          schedule.inject(0) { |sum, block| sum += block[:length] } 
        ).to eq(expected_cells)
      end
    end
  end
end
