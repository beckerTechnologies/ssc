class HomeController < ApplicationController
	before_action :reset_session

  def index
  end

  private

  def reset_session
    session[:login] = nil
  end
  
end
