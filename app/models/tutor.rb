class Tutor < ActiveRecord::Base
  belongs_to :user

  has_many :appointments
  has_many :clients, through: :appointments
end
