class Profile < ActiveRecord::Base
	has_one :contact_info
	has_one :ssc_bank
end
