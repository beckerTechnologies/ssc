class BasicInfo < ActiveRecord::Base
  belongs_to :profile
  #validates :ssn, numericality: { only_integer: true }
  validates :first_name, presence: true, length: { minimum: 2}
  validates :dob, presence: true
  VALID_SSN_REGEX = /\b(\d{3})\D?(\d{2})\D?(\d{4})\b/
  validates :ssn, presence: true, format: { with: VALID_SSN_REGEX }, uniqueness: true
end
