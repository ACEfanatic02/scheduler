require 'spec_helper'

describe Subject do

  before { @subject = Subject.new(course_number: 'CSC200', course_name: "Intro to Computer Science") }

  subject { @subject }

  it { should respond_to(:course_number) }
  it { should respond_to(:course_name) }

  it { should be_valid }  

  describe "when course number is not present" do
    before { @subject.course_number = " " }
    it { should_not be_valid }
  end

  describe "when course name is not present" do
    before { @subject.course_name = " " }
    it { should_not be_valid }
  end
end
