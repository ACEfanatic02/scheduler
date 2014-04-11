require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "registration page" do
    before { visit register_path }

    it { should have_title('Register') }
    it { should have_content('New User') }

    it { should have_field('username') }
    it { should have_field('email') }
    it { should have_field('password') }
    it { should have_field('password_confirmation') }

    it { should have_css('form button', text: "Register") }
    
    describe "registration form validation", js: true do

      it "marks empty fields as errors" do
        click_button('Register')
        expect(page).to have_selector('input[name=username].form-field-error')
        expect(page).to have_selector('input[name=email].form-field-error')
        expect(page).to have_selector('input[name=password].form-field-error')
        expect(page).to have_selector('input[name=password_confirmation].form-field-error')
      end
    end
  end
end
