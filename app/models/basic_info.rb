class BasicInfo < ActiveRecord::Base
  belongs_to :profile
  #validates :ssn, numericality: { only_integer: true }
  validates :first_name, presence: true
  validates :dob, presence: true
  #TODO fix the regex
  VALID_SSN_REGEX = /\A[\d]{3}-[\d]{2}-[d]{4}/i
  validates :ssn, presence: true,
    #format: { with: VALID_SSN_REGEX }, 
    uniqueness: true
end
