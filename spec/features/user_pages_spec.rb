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

      it "marks a long username as an error" do
        fill_in('username', with: "a" * 51)
        click_button('Register')
        expect(page).to have_selector('input[name=username].form-field-error')
        expect(page).to have_selector('div.form-error-list>p.form-error',
                                      text: "Username too long.")
      end

      it "marks a short password as an error" do
        fill_in('password', with: "abcdefg")
        fill_in('password_confirmation', with: "abcdefg")
        click_button('Register')
        expect(page).to have_selector('input[name=password].form-field-error')
        expect(page).to have_selector('div.form-error-list>p.form-error',
                                      text: "Password too short.")
      end

      it "counts whitespace when checking password length" do
        fill_in('password', with: "abcdefg ")
        fill_in('password_confirmation', with: "abcdefg ")
        click_button('Register')
        expect(page).not_to have_selector('input[name=password].form-field-error')
        expect(page).not_to have_selector('div.form-error-list>p.form-error',
                                          text: "Password too short.")
      end

      it "marks unmatched password and confirmation as an error" do
        fill_in('password', with: "foobarbaz")
        fill_in('password_confirmation', with: "notamatch")
        click_button('Register')
        expect(page).to have_selector('input[name=password].form-field-error')
        expect(page).to have_selector('input[name=password_confirmation].form-field-error')
        expect(page).to have_selector('div.form-error-list>p.form-error', 
                                      text: "Password and confirmation do not match.")
      end

      it "includes whitespace in comparing password and confirmation" do
        fill_in('password', with: 'foobarbaz')
        fill_in('password_confirmation', with: 'foobarbaz ')
        click_button('Register')
        expect(page).to have_selector('input[name=password].form-field-error')
        expect(page).to have_selector('input[name=password_confirmation].form-field-error')
        expect(page).to have_selector('div.form-error-list>p.form-error', 
                                      text: "Password and confirmation do not match.")
      end

      it "marks obviously wrong emails as an error" do
        %w[foo+at+bar.com foo@bar @bar.com foo@ foobar.com].each do |invalid_email|
          fill_in('email', with: invalid_email)
          click_button('Register')
          expect(page).to have_selector('input[name=email].form-field-error')
          expect(page).to have_selector('div.form-error-list>p.form-error',
                                        text: "Invalid email address.")
        end
      end
    end
  end
end
