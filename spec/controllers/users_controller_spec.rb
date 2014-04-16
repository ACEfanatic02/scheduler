require 'spec_helper'

describe UsersController do

  describe '#create' do

    describe "with valid user data" do
      before do
        post :create, { username: 'user', email: 'user@example.com', 
                        password: 'password', password_confirmation: 'password' }
      end

      it "redirects to root page" do
        expect(flash[:success]).not_to be_nil
        expect(response).to redirect_to root_url
      end

      it "logs in the new user" do
        created_user = User.find_by_email('user@example.com')
        expect(session[:user_id]).to eq(created_user.id)
      end
    end

    describe "with invalid user data" do
      before do
        post :create, { username: 'user', email: '', password: '', password_confirmation: ' ' }
      end

      it "re-renders the registration form" do
        expect(flash[:success]).to be_nil
        expect(response).to render_template(:new)
      end

      it "does not log in" do
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe "#destroy" do

    describe "with admin rights" do
      before do
        @admin = User.new(username: 'admin', email: 'admin@example.com', 
                          password: 'adminpass', password_confirmation: 'adminpass',
                          admin: true)
        @admin.save!

        session[:user_id] = @admin.id
      end

      describe "with an existing user" do
        before do
          @user = User.new(username: 'user', email: 'user@example.com', 
                           password: 'password', password_confirmation: 'password')
          @user.save!
        end

        it "deletes the user" do
          delete :destroy, { id: @user.id }

          expect(flash[:success]).to_not be_nil
          expect(User.exists?(@user.id)).to be_falsey
        end
      end
    end

    describe "without admin rights" do
      before do
        @user = User.new(username: 'user', email: 'user@example.com', 
                         password: 'password', password_confirmation: 'password')
        @user.save!
      end

      it "redirects to root without deleting user" do
        delete :destroy, { id: @user.id }

        expect(flash[:error]).to_not be_nil
        expect(User.exists?(@user.id)).to be_truthy
        expect(response).to redirect_to root_url
      end
    end
  end
end