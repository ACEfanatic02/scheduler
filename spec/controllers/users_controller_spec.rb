require 'spec_helper'

describe UsersController do

  describe '#index' do
    before do
      @admin = User.create(username: 'admin', email: 'admin@example.com', 
                           password: 'adminpass', password_confirmation: 'adminpass',
                           admin: true)
    end

    describe "without admin rights" do

      it "redirects to root page with an error message" do
        get :index

        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to root_url
      end
    end

    describe "with admin rights" do
      before do
        session[:user_id] = @admin
      end

      it "succeeds" do
        get :index

        expect(flash[:error]).to be_nil
        expect(response.response_code).to eq(200)
      end
    end
  end

  describe '#show' do
    before do
      @admin = User.create(username: 'admin', email: 'admin@example.com', 
                           password: 'adminpass', password_confirmation: 'adminpass',
                           admin: true)
      @user = User.create(username: 'user', email: 'user@example.com', 
                          password: 'password', password_confirmation: 'password')
    end

    describe "when not logged in" do

      it "blocks access to user pages" do
        get :show, { id: @admin }

        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to root_url
      end
    end

    describe "without admin rights" do
      before do
        session[:user_id] = @user
      end

      it "blocks access to a different user's page" do
        get :show, { id: @admin }

        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to root_url
      end

      it "allows access to user's own page" do
        get :show, { id: @user }

        expect(flash[:error]).to be_nil
        expect(response.response_code).to eq(200)
      end
    end

    describe "with admin rights" do
      before do
        session[:user_id] = @admin
      end

      it "allows access to different user's page" do
        get :show, { id: @user }

        expect(flash[:error]).to be_nil
        expect(response.response_code).to eq(200)
      end
    end
  end

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

      describe "with a non-existing user" do

        it "sends the user to root with an error message" do
          delete :destroy, { id: -1 }

          expect(flash[:success]).to be_nil
          expect(flash[:error]).to_not be_nil
          expect(response).to redirect_to root_url
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