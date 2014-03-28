class SetupController < ApplicationController

  layout 'setup'
  
  def new
    @profile = Profile.new
    @ca = Carrier.all
    render  :profile
  end 

  def profile
    @ca = Carrier.all
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
        format.html{ redirect_to :action => :new_ssc}
      else
        format.html{ render :action => :basicinfo}
      end
    end 
  end  
  def new_ssc
    @ssc_bank = SscBank.new
    @ao = AuthOption.all
    @lt = Lifetime.all
    render  :ssc
  end 
  def ssc
    @ao = AuthOption.all
    @lt = Lifetime.all
    @ssc_bank = SscBank.new(ssc_bank_params)
    @ssc_bank.profile_id = session[:pid]
    respond_to do |format|
      if @ssc_bank.save
        format.html{ redirect_to :action => :page3}
      else
        format.html{ render :action => :ssc}
      end
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
            format.html{ redirect_to :action => :page4, notice: 'SSC stored'}
          else
            format.html{ render :action => :page3}
          end
        end
      end
    else 
      flash[:notice] = "Session expired. Hit return to go back. " 
    end 
  end
  def page4
    if session[:ct] && session[:pid]
      @ct = session[:ct]
      if params[:ssc].present?
        @ssc = params[:ssc]
        @pid = session[:pid]
        @ssc_bank = SscBank.find_by! profile_id: @pid
        if @ssc != @ssc_bank[:ssc]
          flash[:notice] = "Incorrect SSC, please try again. (for purpose of testing this is the profile_id = #{@pid} and this is the expected ssc = #{@ssc_bank[:ssc]} #{@ct} ) "
          render :action => :page4
        else
          flash[:notice] = "Congratulations you are done"
          redirect_to :action => :page5
        end
      end
    else 
      flash[:notice] = "Session expired. Hit return to go back. "
    end
  end
  def page5
    if !session[:pid]
      flash[:notice] = "Session expired. Hit return to go back. "
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


