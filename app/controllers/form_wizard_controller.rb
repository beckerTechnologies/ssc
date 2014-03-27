class FormWizardController < ApplicationController
	include Wicked::Wizard

	steps :basic_info, :address_info, :ssc_info

	def show
		@profile = Profile.find(:profile)
		render_wizard
	end

	def update
		
	end
end
