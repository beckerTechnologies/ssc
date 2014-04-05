class Profile < ActiveRecord::Base
  before_save { self.phone_number = phone_number.split(/[() -]/).join()}
  before_save {self.email = email.downcase } 
  has_one :basic_info, :autosave => true
  has_one :address_info, :autosave => true
  has_one :ssc_bank, :autosave => true
  belongs_to :auth_option
  belongs_to :carrier
  accepts_nested_attributes_for :basic_info
  accepts_nested_attributes_for :address_info
  accepts_nested_attributes_for :ssc_bank
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  VALID_PASS_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}\z/
  validates :password, confirmation: true, length: { minimum: 6},format: {with: VALID_PASS_REGEX}
  validates :password_confirmation, presence: true
  validates :carrier_id, presence: true
  VALID_PHON_REGEX = /\A(?=.*\d).{10}\z/
  validates :phone_number, presence: true 
=begin
  #has_secure_password
=end


end
