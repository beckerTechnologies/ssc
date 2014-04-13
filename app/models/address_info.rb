class AddressInfo < ActiveRecord::Base
	belongs_to :profile

=begin
  validates :street_addr, presence: true
  #validates :apartment_no, presence: true
  validates :city, presence: true
  validates :zip_code, presence: true
  validates :state, presence: true
  validates :country, presence: true
=end
  validates :profile_id, 
  	presence: {:message => "Address Info Already Exists"},
end
