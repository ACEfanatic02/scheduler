require 'spec_helper'

describe TutorsController do
  before do
    @admin = User.create!(username: 'admin', email: 'admin@example.com',
                          password: 'password', password_confirmation: 'password',
                          admin: true)
    @user = User.create!(username: 'user', email: 'user@example.com',
                         password: 'password', password_confirmation: 'password')
  end

  describe '#create' do

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

      describe "when subjects are given" do
        before do
          @csc200 = Subject.create!(course_number: "CSC200", course_name: "Intro to Computer Science")
        end

        it "creates a tutor with given subjects" do
          post :create, { user_id: @user, subjects: [@csc200] }
        end
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

  describe '#update' do

    describe "without admin access" do

      it "redirects to root with error message" do
        put :update, { id: @user }

        expect(flash[:error]).to_not be_nil
        expect(response).to redirect_to root_url
      end
    end

    describe "with admin access" do
      before do
        login_as @admin
      end

      describe "with non-existant tutor" do

        # TODO: where should we redirect?
        it "displays an error message" do
          put :update, { id: @user }

          expect(flash[:error]).to_not be_nil
        end
      end

      describe "with existing tutor" do
        before do
          @user.build_tutor.save!
          @csc200 = Subject.create!(course_number: "CSC200", course_name: "Intro to Computer Science")
        end

        let(:tutor) { @user.tutor }

        it "updates the tutor" do
          expect {
              put :update, { id: tutor, subjects: [@csc200] }
            }.to change(tutor.subjects, :count).by(1)
        end

        describe "with multiple subjects" do
          before do
            @eng111 = Subject.create!(course_number: "ENG111", course_name: "College Composition I")
            @mth173 = Subject.create!(course_number: "MTH173", course_name: "Calculus I")
          end

          it "should add all subjects" do
            expect {
              put :update, { id: tutor, subjects: [@csc200, @eng111, @mth173] }
            }.to change(tutor.subjects, :count).by(3)
          end
        end

        describe "for subject tutor already teaches" do
          before do
            tutor.subjects << @csc200
          end

          it "should not change the tutor's subjects" do
            expect {
              put :update, { id: tutor, subjects: [@csc200] }
            }.to_not change(tutor.subjects, :count)
          end
        end
      end
    end
  end
end
