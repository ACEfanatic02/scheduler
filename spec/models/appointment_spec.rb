require 'spec_helper'

describe Appointment do

  before do
    client_user = User.new(username: 'client', email: 'client@example.com',
                           password: 'password', password_confirmation: 'password')
    tutor_user = User.new(username: 'tutor', email: 'tutor@example.com',
                          password: 'password', password_confirmation: 'password')
    client_user.save!
    tutor_user.save!

    @client = client_user.build_client
    @tutor = tutor_user.build_tutor

    @client.save!
    @tutor.save!

    @appointment = Appointment.new(client: @client, tutor: @tutor)
  end

  subject { @appointment }

  it { should respond_to(:client) }
  it { should respond_to(:tutor) }

  it { should be_valid }

  it "can access client and tutor instances" do
    expect(@appointment.client).to eq(@client)
    expect(@appointment.tutor).to eq(@tutor)
  end
end
