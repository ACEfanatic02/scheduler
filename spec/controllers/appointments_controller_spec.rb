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
end
