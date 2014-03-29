class FormWizardController < ApplicationController
	include Wicked::Wizard

	steps :email_info, :address_info

	def show
		@profile = Profile.find_by id: session[:pid]
		render_wizard
	end

	def update
		
	end
end
