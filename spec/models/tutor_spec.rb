require 'spec_helper'

describe Tutor do

  before do
    @user = User.new(username: "test1234", email: "test1234@example.com",
                     password: "foobarbaz", password_confirmation: "foobarbaz")
    @user.save!
    @tutor = @user.build_tutor
  end

  subject { @tutor }

  it { should respond_to(:user) }
  it { should respond_to(:appointments) }
  it { should respond_to(:clients) }

  it { should be_valid }

  it "can access its user instance" do
    expect(@tutor.user).to eq(@user)
  end 
end
