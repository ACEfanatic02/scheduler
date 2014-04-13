class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  has_one :tutor
  has_one :client

  # "Proper' regex is a loser's game here.
  # Just check for something vaugely email-shaped.
  VALID_EMAIL_REGEX = /.+@.+\..+/

  validates :username, presence: true, length: { maximum: 50 } 
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 8 }
end
