require 'spec_helper'

describe SessionsController do
  before do
    @user = User.new(username: 'user', email: 'user@example.com',
                     password: 'password', password_confirmation: 'password')
    @user.save!
  end

  describe '#create' do
    it 'logs in user with correct credentials' do
      post :create, email: 'user@example.com', password: 'password'
      expect(session[:user_id]).to eq(@user.id)
    end

    it 'does not log in user with incorrect credentials' do
      post :create, email: 'user@example.com', password: 'wrongpassword'
      expect(session[:user_id]).not_to eq(@user.id)
    end
  end

  describe '#destroy' do
    before do
      post :create, email: 'user@example.com', password: 'password'
    end

    it 'logs out current user' do
      delete :destroy
      expect(session[:user_id]).not_to eq(@user.id)
    end
  end
end
