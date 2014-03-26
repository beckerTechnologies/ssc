class SetupController < ApplicationController
  
  def initialize # to display errors one per line, otherwise delete this. 
    @profile = Profile.new
    @basic = @profile.build_basic_info # BasicInfo.new
    @bank = SscBank.new
  end
  def page1
    flash.clear
    @profile = Profile.new
    @basic_info = @profile.build_basic_info
    @ao = AuthOption.all
    @lt = get_lifetime
  end
  def create
    @ao = AuthOption.all
    @lt = get_lifetime
    #TODO why are labels and fields not in the same line after a validation error occurs on that field ? 
    #TODO retain values in the form after validation errors are encountered. 
    profile_params.permit!
    @profile = Profile.new(profile_params)

    params[:profile][:basic_info].permit!
    @basic = BasicInfo.new(params[:profile][:basic_info])
    @basic[:ssn] = @basic[:ssn].tr('-','')

    @profile.valid?
    @basic.valid?

    if @profile.errors.present? || @basic.errors.present?
      flash[:error] = "#{@profile.errors.full_messages.to_sentence} - #{@basic.errors.full_messages.to_sentence}" # to display all errors in one line 
      render :action=>'page1'
    else
      @profile.save!
      @basic[:profile_id] = @profile[:id]
      @basic.save!
      flash[:error] = "Successfully created profile. #{@profile[:id]}"
      session[:pid] = @profile[:id]
      redirect_to :action => :page2
    end
  end
  def page2
    #session[:pid] = 11 #@profile[:id] # remove this after testing.
  end
  def page3

    if session[:pid]
      @pid = session[:pid]
      @profile = Profile.find(@pid) #session[:pid])
      if params[:ct_mask].present?
        @profile_id = @profile[:id]
        @lifetime = @profile[:ssc_lifetime]
        @ssc_val = @profile[:ssc_value]
        @ct_mask = params[:ct_mask]
        @ct = set_ct #rand(10) # single digit ct
        @ssc = set_ssc(@ct, @ssc_val, @ct_mask)
        @expiry = set_expiry(@lifetime)
        flash[:notice] = @ct
        session[:ct] = @ct
        @sscbank = {ct_mask: params[:ct_mask], profile_id:@profile_id, lifetime: @lifetime, expiry:@expiry, ssc:@ssc}
        @ssc_bank = SscBank.new(@sscbank )
        @ssc_bank.valid?
        if @ssc_bank.errors.present?
          flash[:error] = "#{@ssc_bank.errors.full_messages.to_sentence}"
          render :action => :page3
        else
          @ssc_bank.save!
          #flash[:error] = "successfully created SSC"
          redirect_to :action => :page4
        end
      end
    else 
      flash[:error] = "Session expired. Hit return to go back. " 
    end 

  end
  def page4
    if session[:ct] && session[:pid]
      flash[:notice] = session[:ct]
      if params[:ssc].present?
        @ssc = params[:ssc]
        @pid = session[:pid]
        @ssc_bank = SscBank.find_by! profile_id: @pid
        flash[:error] = "here #{@pid} - #{@ssc_bank}"
        if @ssc != @ssc_bank[:ssc]
          flash[:error] = "Incorrect SSC, please try again. (for purpose of testing this is the profile_id = #{@pid} and this is the expected ssc = #{@ssc_bank[:ssc]} ) "
          render :action => :page4
        else
          flash[:error] = "Congratulations you are done"
          redirect_to :action => :page5
        end
      end
    else 
      flash[:error] = "Session expired. Hit return to go back. "
    end
  end
  def page5
    if !session[:pid]
      flash[:error] = "Session expired. Hit return to go back. "
    else
      @pid = session[:pid]
      if params[:sendnew].present?
        RenewWorker.perform_async(@pid)
        flash[:success] = true
      end
    end
  end
  def show
    @profiles = Profile.all
    @basic = BasicInfo.all
    @sscbank = SscBank.all

  end

  private

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation, :phone_number, :street_addr, :apartment_no, :city, :state, :zip_code, :country, :auth_option_id,  :ssc_value, :ssc_lifetime, basic_info_attributes: [:id, :first_name, :middle_name, :last_name, :dob, :ssn] )
  end
end

