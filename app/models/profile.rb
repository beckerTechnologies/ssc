class Profile < ActiveRecord::Base
  before_save { self.email = email.downcase }
  has_one :basic_info, :autosave => true
  has_one :ssc_bank, :autosave => true
  belongs_to :auth_option
  accepts_nested_attributes_for :basic_info
  #accepts_nested_attributes_for :ssc_bank
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  VALID_PASS_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}\z/
  validates :password, confirmation: true, length: { minimum: 6},format: {with: VALID_PASS_REGEX}
  validates :password_confirmation, presence: true
=begin
  #has_secure_password
  validates :phone_number, presence: true
  validates :street_addr, presence: true
  #validates :apartment_no, presence: true
  validates :city, presence: true
  validates :zip_code, presence: true
  validates :state, presence: true
  validates :country, presence: true
=end
  validates :auth_option_id, presence: true
  validates :ssc_value, presence: true
  validates :ssc_lifetime, presence: true
end
