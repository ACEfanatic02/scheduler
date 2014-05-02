require 'spec_helper'

describe "Schedule pages" do
  before do
    @alice = User.create!(username: 'alice', email: 'alice@example.com',
                          password: 'password', password_confirmation: 'password')
    @bob = User.create!(username: 'bob', email: 'bob@example.com',
                        password: 'password', password_confirmation: 'password')
    @csc200 = Subject.create!(course_number: 'CSC200', course_name: 'Intro to Computer Science')
    @eng111 = Subject.create!(course_number: 'ENG111', course_name: 'College Composition I')
    @alice.build_tutor(subjects: [@csc200]).save!
    @bob.build_tutor(subjects: [@eng111]).save!

  end

  describe "page contents" do
    before do
      @today = DateTime.civil_from_format(:local, 2014, 3, 31)
      login_as 'bob@example.com', 'password'
      visit schedule_path(start_date: @today)
    end

    it "has the right title" do
      expect(page).to have_title("Monday March 31 - Friday April 4")
    end

    it "has tables for each weekday" do
      ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"].each do |weekday|
        expect(page).to have_css('.schedule-table-day-header', text: weekday)
      end
    end

    it "does not have tables for the weekend" do
      ["SATURDAY", "SUNDAY"].each do |weekend|
        expect(page).to have_no_css('.schedule-table-day-header', text: weekend)
      end
    end

    it "has a row of times for each day" do
      expect(all('.schedule-table-time-header').count).to eq(5 * 10)
    end

    it "has a row for each tutor every day" do
      # TODO:  Tutors with a completely blacked-out schedule for a particular day
      # should *not* show up -- but we don't have blackouts implmented yet.
      expect(all('.schedule-table-tutor-name', text: 'alice').count).to eq(5)
      expect(all('.schedule-table-tutor-name', text: 'bob').count).to eq(5)
    end

    describe "schedule blocks" do
      before do
        @alice.tutor.appointments.create(client: @bob.create_client, subject: @csc200,
                                         start_time: @today.change(hour: 9), end_time: @today.change(hour: 9, min: 30))
        visit schedule_path(start_date: @today)
      end

      it "should contain an appointment with the right time" do
        expect(page).to have_link("\u00A0", href: appointments_path(@alice.tutor, @today.change(hour: 9)))
      end
    end
  end

  describe "making an appointment" do

    before do
      @today = DateTime.civil_from_format(:local, 2014, 3, 31)
      login_as 'bob@example.com', 'password'
      visit schedule_path(start_date: @today)
      click_link("\u00A0", href: appointments_path(@alice.tutor, @today.change(hour: 10)))
    end

    describe 'form contents' do
      subject { page }

      it { should have_selector('select[name=subject]') }
      it { should have_selector('input[type=radio][name=length][value="15"]') }
      it { should have_selector('input[type=radio][name=length][value="30"]') }
      it { should have_field('notes') }

      it { should have_button('Save') }
      it { should have_button('Cancel') }
    end

    describe 'form validation', js: true do

      it 'requires a subject to be selected' do

        click_button 'Save'

        expect(page).to have_selector('select[name=subject].form-field-error')
      end

      it 'rejects empty notes if "Other" subject is selected' do
        select 'Other', from: 'subject'

        click_button 'Save'

        expect(page).to have_selector('textarea[name=notes].form-field-error')
      end

      it 'does not require notes for actual subjects' do
        select 'CSC200', from: 'subject'

        click_button 'Save'

        expect(page).to have_no_selector('.flash-error')
        expect(page).to have_selector('.flash-success')
      end
    end
  end
end
