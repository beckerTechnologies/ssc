class BasicInfo < ActiveRecord::Base
  before_validation { self.ssn = ssn.split(/[() -]/).join()}
  belongs_to :profile

  validates :first_name, 
  	presence: {:message => "cannot be blank"}, 
  	length: { minimum: 2, :message => "is too short"}

  validates :dob, 
  	presence: {:message => "cannot be blank"}

  validates :ssn, 
  	presence: {:message => "cannot be blank"},
  	uniqueness: {:message => "is already used, please use another one"}

end
