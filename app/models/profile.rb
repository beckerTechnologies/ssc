class Profile < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_one :contact_info
  has_one :ssc_bank
  belongs_to :auth_option
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  #validates :password_confirmation, presence: true
end
