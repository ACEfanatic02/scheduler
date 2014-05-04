require 'spec_helper'

describe AppointmentsController do

  describe '#new' do
    before do
      user = User.create!(username: 'user', email: 'user@example.com',
                          password: 'password', password_confirmation: 'password')
      @tutor = user.create_tutor
      client_user = User.create!(username: 'client', email: 'client@example.com',
                                password: 'password', password_confirmation: 'password')
      @client = client_user.create_client
    end

    describe 'when not logged in' do

      it 'should redirect to login' do
        get :new, tutor_id: @tutor, start_time: Time.now.beginning_of_week.change(hour: 10)

        expect(response).to redirect_to login_url
        expect(session[:return_to]).to eq(appointments_path(@tutor, Time.now.beginning_of_week.change(hour: 10)))
      end
    end

    describe 'when logged in' do
      before { login_as @client.user }

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
      login_as client_user
    end


    let!(:monday_at_ten) { Time.now.beginning_of_week.change(hour: 10) }

    it 'should reject invalid data' do
      post :create, tutor_id: -1, client_id: @client, start_time: monday_at_ten, length: 15, subject: @subject

      expect(flash[:error]).to_not be_nil
    end

    it 'should accept valid data' do
      post :create, tutor_id: @tutor.id, client_id: @client.id, start_time: monday_at_ten, length: 15, subject: @subject.id

      expect(flash[:error]).to be_nil
      expect(flash[:success]).to_not be_nil
    end
  end
end
