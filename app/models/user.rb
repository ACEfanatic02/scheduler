class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  after_create :force_client

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

  def tutor?
    !tutor.nil?
  end

  def force_client
    !client.nil? || create_client!
  end
end
