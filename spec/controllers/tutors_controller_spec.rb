require 'spec_helper'

describe TutorsController do

  describe '#create' do
    before do
      @admin = User.create!(username: 'admin', email: 'admin@example.com',
                            password: 'password', password_confirmation: 'password',
                            admin: true)
      @user = User.create!(username: 'user', email: 'user@example.com',
                           password: 'password', password_confirmation: 'password')
    end

    describe "without admin access" do

      it "redirects to root with error message" do
        post :create, { user_id: @user }

        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to root_url
      end
    end

    describe "with admin access" do
      before do
        login_as @admin
      end

      it "creates a tutor instance for an existing user" do
        post :create, { user_id: @user }

        expect(flash[:error]).to be_nil
        expect(flash[:success]).to_not be_nil

        expect(Tutor.find_by_user_id(@user)).to_not be_nil
      end

      describe "when user is already a tutor" do
        before do
          @user.build_tutor.save!
        end

        it "redirects to tutor's user page" do
          post :create, { user_id: @user }

          expect(flash[:success]).to be_nil
          expect(flash[:notice]).to_not be_nil
          expect(response).to redirect_to users_path(@user)
        end
      end
    end
  end
end
