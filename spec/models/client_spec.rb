require 'spec_helper'

describe Client do

  before do
    @user = User.new(username: "test1234", email: "test1234@example.com",
                     password: "foobarbaz", password_confirmation: "foobarbaz")
    @user.save!
    @client = @user.client
  end

  subject { @client }

  it { should respond_to(:user) }
  it { should respond_to(:appointments) }
  it { should respond_to(:tutors) }

  it { should be_valid }

  it "can access its user instance" do
    expect(@client.user).to eq(@user)
  end
end
