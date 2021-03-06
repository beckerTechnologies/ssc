class SetupController < ApplicationController
  before_action :check_session, except: [:caution, :welcome_setup,:new,:profile, :show]
  skip_before_filter :verify_authenticity_token
  layout 'setup'

  def caution
  end

  def welcome_setup
  end

  def new
    @profile = Profile.new
    render  :profile
  end 

  def profile
    @profile = Profile.new(profile_params)
    respond_to do |format|
      if @profile.save
        session[:pid] = @profile.id
        format.html{ redirect_to :action => :new_info}
      else
        format.html{ render :action => :profile}
      end
    end
  end
  def new_info
    @basic_info = BasicInfo.new
    render  :basicinfo
  end 
  def basicinfo
    @basic_info = BasicInfo.new(basic_info_params)
    @basic_info.profile_id = session[:pid]
    respond_to do |format|
      if @basic_info.save
        format.html{ redirect_to :action => :new_addr_info}
      else
        format.html{ render :action => :basicinfo}
      end
    end 
  end

  def new_addr_info
    @address_info = AddressInfo.new
    render  :addressinfo
  end 
  def addressinfo
    @address_info = AddressInfo.new(address_info_params)
    @address_info.profile_id = session[:pid]
    respond_to do |format|
      if @address_info.save
        format.html{ redirect_to :action => :welcome_ssc}
      else
        format.html{ render :action => :addrinfo}
      end
    end 
  end

  def welcome_ssc
    # redirect_to :action => :new_ssc
  end

  def new_ssc
    @ssc_bank = SscBank.new
    @ssn = (BasicInfo.find_by profile_id: session[:pid]).ssn
    @phn = (Profile.find session[:pid]).phone_number
    render  :ssc
  end 
  def ssc
    @ssc_bank = SscBank.new(ssc_bank_params)
    @ssn = (BasicInfo.find_by profile_id: session[:pid]).ssn
    @phn = (Profile.find session[:pid]).phone_number
    begin
    if @ssc_bank.auth_value && AuthOption.find(@ssc_bank.auth_option_id).length 
      if AuthOption.find(@ssc_bank.auth_option_id).length==@ssc_bank.auth_value.length
        @ssc_bank.profile_id = session[:pid]
        respond_to do |format|
          if @ssc_bank.save
            format.html{ redirect_to :action => :page3}
          else
            format.html{ render :action => :ssc}
          end
        end
      else 
        flash.now[:notice] = "Please enter a valid value for Personal Identifier"  
      end
    end
    rescue
      flash.now[:notice] = "Invalid selection"
    end
    #flash.now[:notice] = "You entered noooooo" #{@ssc_bank.auth_value.length} digits, while #{AuthOption.find(@ssc_bank.auth_option_id).name} should be #{AuthOption.find(@ssc_bank.auth_option_id).length} digits long" 
  end
  def page3
    @pid = session[:pid]
    @ssc_bank = SscBank.find_by profile_id: @pid
    @len = (AuthOption.find(@ssc_bank[:auth_option_id]))[:length] # for the view
    @ssc_o = @ssc_bank[:auth_value]
    if params[:ct_mask].present?
      @ct_mask = params[:ct_mask]
      @ct = set_ct 
      session[:ct] = @ct
      @ssc = set_ssc(@ct, @ssc_bank[:auth_value], @ct_mask)
      @lifetime = (Lifetime.find(@ssc_bank[:lifetime_id]))[:hours]
      @expiry = set_expiry(@lifetime)

      @ssc_bank.expiry = @expiry 
      @ssc_bank.ct_mask = @ct_mask
      @ssc_bank.ssc = @ssc 
      respond_to do |format|
        if @ssc_bank.save!
          format.html{ redirect_to :action => :commit_to_memory }
        else
          format.html{ render :action => :page3}
        end
      end
    end
  end
  def commit_to_memory
    @pid = session[:pid]
    @ssc_bank = SscBank.find_by profile_id: @pid
    @ct_mask = @ssc_bank.ct_mask
  end
  def page4
    @pid = session[:pid]
    if params[:sendnew].present?
      #RenewWorker.perform_async(@pid)
      mail_ct_helper(@pid)
      flash[:success] = true
    end
  end

  def show
    @profiles = Profile.all
    @basic = BasicInfo.all
    @sscbank = SscBank.all
    @address_infos = AddressInfo.all
  end

  private

  def check_session
    if !session[:pid]
      flash[:alert] = "Session expired. Please Start Over!"
      redirect_to :controller => :home, :action => :index
    end
  end

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation, :home_phone_number, :phone_number, :carrier_id )
  end

  def basic_info_params
    params.require(:basic_info).permit(:first_name, :middle_name, :last_name, :dob, :ssn)
  end

  def address_info_params
    params.require(:address_info).permit(:street_addr, :apartment_no, :city, :state, :zip_code, :country)
  end

  def ssc_bank_params
    params.require(:ssc_bank).permit(:auth_option_id, :auth_value, :ssc, :ct_mask, :lifetime_id) 
  end
end
