require 'spec_helper'

describe AppointmentsController do

  describe '#new' do
    before do
      user = User.create!(username: 'user', email: 'user@example.com',
                          password: 'password', password_confirmation: 'password')
      @tutor = user.create_tutor
    end

    it 'should reject an invalid tutor id' do
      get :new, tutor_id: 42, start_time: Time.now.beginning_of_week.change(hour: 10)

      expect(response.response_code).to_not eq(200)
      expect(flash[:error]).to_not be_nil
    end

    it 'accepts a valid tutor id' do
      get :new, tutor_id: @tutor, start_time: Time.now.beginning_of_week.change(hour: 10)

      expect(response.response_code).to eq(200)
      expect(flash[:error]).to be_nil
    end
  end

  describe '#create' do
    before do
      user = User.create!(username: 'user', email: 'user@example.com',
                          password: 'password', password_confirmation: 'password')
      @tutor = user.create_tutor
      client_user = User.create!(username: 'client', email: 'client@example.com',
                          password: 'password', password_confirmation: 'password')
      @client = client_user.create_client
      @subject = Subject.create!(course_number: 'SUB123', course_name: 'Test Subject')
      @tutor.subjects << @subject
    end


    let!(:monday_at_ten) { Time.now.beginning_of_week.change(hour: 10) }

    it 'should reject invalid data' do
      post :create, tutor: -1, client: @client, start_time: monday_at_ten, length: 15, subject: @subject

      expect(flash[:error]).to_not be_nil
    end

    it 'should accept valid data' do
      post :create, tutor: @tutor, client: @client, start_time: monday_at_ten, length: 15, subject: @subject

      expect(flash[:error]).to be_nil
      expect(flash[:success]).to_not be_nil
    end
  end
end
