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
  validates :email, 
    presence: {:message => "cannot be blank"}, 
    format: { with: VALID_EMAIL_REGEX, :message => "format is not correct"},
    uniqueness: { case_sensitive: false }

  VALID_PASS_REGEX = /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}\z/
  
  validates :password, confirmation: true, length: { minimum: 6},format: {with: VALID_PASS_REGEX}, on: :create
  validates_presence_of :password_confirmation, :if => :password?, on: :create

  # if phone number is present only then check presence of carrier id. 
  validates_presence_of :carrier_id, :if => :phone_number?,
    presence: {:message => "cannot be blank"}

=begin
  # comenting this out to make phone number optional. 

  #validates :carrier_id, 
  #  presence: {:message => "cannot be blank"}
  # VALID_PHON_REGEX = /\A(?=.\d{3}\)?[- ]?\d{3}[- ]?\d{4}).{13}\z/
  #validates :phone_number,
  # presence: {:message => "cannot be blank"}#,
=end
  # format: {with: VALID_PHON_REGEX, :message => "is not correct"}
  # length: { is: 13, :message => "is too short"}

  #has_secure_password



end
