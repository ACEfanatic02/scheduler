require 'spec_helper'

describe "Tutor pages" do
  before do
    @user = User.create(username: 'alice', email: 'alice@example.com',
                        password: 'password', password_confirmation: 'password')
    @user.build_tutor.save!
    @user.tutor.subjects << Subject.create(course_number: "CSC200", course_name: "Intro to Computer Science")
  end

  describe "tutor index" do

    it "lists the tutors" do
      visit tutors_path

      expect(page).to have_selector('h1', text: "Tutors")
      expect(page).to have_link('alice', href: tutors_path(@user.tutor))
    end
  end

  describe "tutor page" do

    it "lists the tutor's information" do
      visit tutor_path(@user.tutor)

      expect(page).to have_content("CSC200")
      expect(page).to have_content("Intro to Computer Science")
    end
  end
end
