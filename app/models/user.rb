class User < ActiveRecord::Base
  # "Proper' regex is a loser's game here.
  # Just check for something vaugely email-shaped.
  VALID_EMAIL_REGEX = /.+@.+\..+/

  validates :username, presence: true, length: { maximum: 50 } 
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
end
