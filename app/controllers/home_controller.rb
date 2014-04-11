class HomeController < ApplicationController
	before_action :reset_session
	skip_before_filter :verify_authenticity_token

  def index
  end

  private

  def reset_session
    session[:login] = nil
  end
  
end
