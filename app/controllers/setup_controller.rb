class SetupController < ApplicationController
  before_action :reset_session, only: [:welcome_setup]
  before_action :check_session, except: [:welcome_setup, :show]
  layout 'setup'
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
        format.html{ redirect_to :action => :welcome_ssc}
      else
        format.html{ render :action => :basicinfo}
      end
    end 
  end

  def welcome_ssc

    # redirect_to :action => :new_ssc
  end

  def new_ssc
    @ssn = (BasicInfo.find_by profile_id: session[:pid]).ssn
    @ssc_bank = SscBank.new
    render  :ssc
  end 
  def ssc
    @ssc_bank = SscBank.new(ssc_bank_params)
    @ssn = (BasicInfo.find_by profile_id: session[:pid]).ssn
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
      flash[:notice] = "You entered #{@ssc_bank.auth_value.length} digits, while #{AuthOption.find(@ssc_bank.auth_option_id).name} should be #{AuthOption.find(@ssc_bank.auth_option_id).length} digits long" # TODO figure out what to do ?
    end
  end

  def page2
    session[:pid] = 1 #@profile[:id] # remove this after testing.
  end
  def page3

    if session[:pid]
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
    else 
      flash[:notice] = "Session expired. Hit return to go back. " 
      redirect_to :controller => :home, :action => :index 
    end 
  end
  def commit_to_memory
    @pid = session[:pid]
    @ssc_bank = SscBank.find_by profile_id: @pid
    @ct_mask = @ssc_bank.ct_mask
  end
  def page4
    if session[:ct] && session[:pid]
      @ct = session[:ct]
      @pid = session[:pid]
      @ssc_bank = SscBank.find_by profile_id: @pid
      if params[:ssc].present?
        @ssc = params[:ssc]
        @pid = session[:pid]
        @ssc_bank = SscBank.find_by profile_id: @pid
        if @ssc != @ssc_bank[:ssc]
          flash[:notice] = "Incorrect SSC, please try again." 
          render :action => :page4
        else
          flash[:notice] = "Congratulations you are done"
          redirect_to :action => :page5
        end
      end
    else 
      flash[:notice] = "Session expired. Hit return to go back. "
      redirect_to :controller => :home, :action => :index 
    end
  end
  def page5
    if !session[:pid]
      flash[:notice] = "Session expired. Hit return to go back. "
      redirect_to :controller => :home, :action => :index 
    else
      @pid = session[:pid]
      if params[:sendnew].present?
        #RenewWorker.perform_async(@pid)
        mail_helper(@pid)
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

  def reset_session
    session[:login] = nil
  end

  def check_session
    if !session[:pid]
      flash[:alert] = "Session expired. Hit return to go back. "
      redirect_to :controller => :home, :action => :index
    end
  end

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation, :phone_number, :street_addr, :apartment_no, :city, :state, :zip_code, :country, :carrier_id )
  end

  def basic_info_params
    params.require(:basic_info).permit(:first_name, :middle_name, :last_name, :dob, :ssn)
  end

  def ssc_bank_params
    params.require(:ssc_bank).permit(:auth_option_id, :auth_value, :ssc, :ct_mask, :lifetime_id) 
  end
end
