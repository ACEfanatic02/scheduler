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

      it "submits a valid form" do
        fill_in('username', with: 'user')
        fill_in('email', with: 'user@example.com')
        fill_in('password', with: 'password') 
        fill_in('password_confirmation', with: 'password')

        expect { click_button('Register') }.to change(User, :count).by(1)
      end
    end
  end

  describe "login page" do
    before { visit login_path }

    it { should have_title("Login") }
    it { should have_content("Login") }

    it { should have_field('email') }
    it { should have_field('password') }

    it { should have_css('form button', text: 'Login') }

    describe "form validation", js: true do
      it "marks empty fields as errors" do
        click_button('Login')
        expect(page).to have_selector('input[name=email].form-field-error')
        expect(page).to have_selector('input[name=password].form-field-error')
      end

      it "does no other validation" do
        fill_in('email', with: 'foo')
        fill_in('password', with: 'bar')

        click_button('Login')

        expect(page).to have_no_selector('.form-field-error')
      end
    end

    describe "form submission", js: true do
      before do
        user = User.new(username: 'user', email: 'user@example.com',
                        password: 'password', password_confirmation: 'password')
        user.save!
      end

      it "rejects wrong credentials" do
        fill_in('email', with: 'user@example.com')
        fill_in('password', with: 'wrongpassword')

        click_button('Login')
        expect(page).to have_selector('.flash-message-error', text: "Invalid email or password.")
      end

      it "succeeds with correct credentials" do
        fill_in('email', with: 'user@example.com')
        fill_in('password', with: 'password')

        click_button('Login')
        expect(page).to have_selector('.flash-message-success', text: "Successfully logged in.")
      end
    end
  end

  describe "users index do", js: true do
    before do
      User.create(username: 'admin', email: 'admin@example.com',
                  password: 'password', password_confirmation: 'password', admin: true)
      User.create(username: 'user', email: 'user@example.com',
                  password: 'password', password_confirmation: 'password')
    end

    describe "while not logged in" do
      before { visit users_path }

      it "should display an error" do
        expect(page).to have_selector('.flash-message-error', text: "This action requires administrative privileges.")
      end
    end

    describe "when logged in as a user" do
      before do
        login_as 'user@example.com', 'password'
        visit users_path
      end

      it "should display an error" do
        expect(page).to have_selector('.flash-message-error', text: "This action requires administrative privileges.")
      end
    end

    describe "when logged in as an admin" do
      before do
        login_as 'admin@example.com', 'password'
        visit users_path
      end

      it "should not display an error" do
        expect(page).to have_no_selector('.flash-message-error')
      end
    end
  end
end
