class Client < ActiveRecord::Base
  belongs_to :user

  has_many :appointments
  has_many :tutors, through: :appointments
end
