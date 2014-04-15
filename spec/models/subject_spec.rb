require 'spec_helper'

describe Subject do

  before { @subject = Subject.new(course_number: 'CSC200', course_name: "Intro to Computer Science") }

  subject { @subject }

  it { should respond_to(:course_number) }
  it { should respond_to(:course_name) }

  it { should respond_to(:tutors) }

  it { should be_valid }  

  describe "when course number is not present" do
    before { @subject.course_number = " " }
    it { should_not be_valid }
  end

  describe "when course name is not present" do
    before { @subject.course_name = " " }
    it { should_not be_valid }
  end

  describe "with duplicate course_number" do
    before do 
      @subject.save!
    end

    it "should not be valid with duplicate" do
      duplicate = Subject.new(course_number: @subject.course_number, 
                              course_name: @subject.course_name)
      expect(duplicate).to_not be_valid
    end
  end

  describe "tutors" do
    before do
      @tutor = Tutor.new
      @tutor.subjects << @subject
      @tutor.save!
    end

    it "can access a list of tutors who teach this subject" do
      expect(@subject.tutors.exists?(@tutor)).to be_truthy
    end
  end
end
