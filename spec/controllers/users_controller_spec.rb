require 'spec_helper'

describe UsersController do

  describe '#create' do

    it "redirects to root page for a valid user" do
      post :create, { username: 'user', email: 'user@example.com', 
                      password: 'password', password_confirmation: 'password' }
      expect(flash[:success]).not_to be_nil
      expect(response).to redirect_to root_url
    end

    it "logs in newly created user" do
      post :create, { username: 'user', email: 'user@example.com', 
                      password: 'password', password_confirmation: 'password' }
      created_user = User.find_by_email('user@example.com')
      expect(session[:user_id]).to eq(created_user.id)
    end

    it "re-renders the form for an invalid user" do
      post :create, { username: 'user', email: '', password: '', password_confirmation: ' ' }
      expect(flash[:success]).to be_nil
      expect(response).to render_template(:new)
    end
  end
end