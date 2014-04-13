class SscBank < ActiveRecord::Base
  belongs_to :profile
  belongs_to :lifetime

  validates :auth_option_id, 
  	presence: {:message => "cannot be blank"}

  validates :auth_value, 
  	presence: {:message => "cannot be blank"}

  validates :lifetime, 
  	presence: {:message => "cannot be blank"}

  validates :profile_id, 
  	presence: {:message => "SSC profile Already Exists"},
end
