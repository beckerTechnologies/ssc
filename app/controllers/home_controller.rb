class HomeController < ApplicationController
  def index
    @au = AuthOption.new
    @au[:name] = "license"
    @au[:length] = 3
    @au.valid?
    if @au.errors.present?
      flash[:error] = "#{@au.errors.full_messages.to_sentence}"
    else
      @au.save!
      flash[:error] = "Successfully created profile. #{@au[:id]}"
    end
  end

  def about
  end
end
