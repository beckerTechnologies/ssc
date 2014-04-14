class LoginController < ApplicationController
  before_action :check_session, except: [:page1, :forgot_pass, :forgot_pass2]
  before_action :set_values, only: [:page3, :view, :update]
  skip_before_filter :verify_authenticity_token

  layout :layout_by_resource

  def layout_by_resource
    if action_name == 'true_resp' or action_name == 'false_resp'
      "empty"
    else
      "login"
    end
  end

  def true_resp
  end
  def false_resp
  end

  def page1
    if params[:email].present? 
      @email = params[:email].tr(' ','').downcase
      if @email.length!=0 
        begin
          @profile = Profile.find_by! email: @email
          if @profile.password != params[:password] # password mismatched
            raise "password mismatch"
          else
            session[:login] = @profile[:id]
            redirect_to :action => :welcome_login
          end
        rescue 
          flash.now[:notice] = "Your email or password is incorrect. Please correct this in order to continue."  
        end
      end
    end
  end

  def welcome_login
    @pid = session[:login]
    @opt = nil
    @opt = 7 unless (SscBank.find_by profile_id: @pid)
    if(@opt != 7)
      @opt = 7 if ((SscBank.find_by profile_id: @pid).ssc==nil)
    end
    @opt = 8 unless (AddressInfo.find_by profile_id: @pid)
    @opt = 9 unless (BasicInfo.find_by profile_id: @pid)
    if(@opt) # ssc is nowqdzsetup alreay. 
      session[:pid] = session[:login]
      session[:opt] = 1 # 1. ssc is setup
      case @opt
      when 7
        redirect_to :controller => :setup, :action => :welcome_ssc
      when 8
        flash[:notice] = "Please enter your valid usa address. "
        redirect_to :controller => :setup, :action => :new_addr_info
      when 9
        flash[:notice] = "Please set up your personal information. "
        redirect_to :controller => :setup, :action => :new_info
      end
    end  

    if params[:ssc].present? 
      @ssc = params[:ssc].tr(' ','')
      if @ssc.length!=0 
        begin
          @sscVal = SscBank.find_by profile_id: @pid
          if @sscVal.ssc != @ssc || @sscVal[:expiry] < Time.now # ssc mismatched or expired
            flash.now[:notice] = "Invalid SSC" 
            raise "ssc mismatch"
          else
            session[:opt] = 4 # 4. ssc entered.
            redirect_to :action => :view
          end
        rescue 
          flash.now[:notice] = "Invalid SSC" 
        end
      end
    end
end
  def checkSSC
    @pid = session[:login]
    if (params[:data] != (SscBank.find_by profile_id: @pid).auth_value)
      render :false_resp
    else 
      render :true_resp
    end
  end
  def checkBoxCode
    @pid = session[:login]
    if (params[:data] != (SscBank.find_by profile_id: @pid).ct_mask)
      render :false_resp
    else
      render :true_resp
    end
  end
  def checkCT
    @pid = session[:login]
    if (params[:data] != (SscBank.find_by profile_id: @pid).ssc)
      render :false_resp
    else
      render :true_resp
    end
  end
  def sendNewCT
    @pid = session[:login]
    #RenewWorker.perform_async(@pid)
    mail_ct_helper(@pid)
    render :true_resp
  end
  
  def sendNewBC
    @pid = session[:login]
    if (params[:ct]).present?
      key_ct = params[:ct].strip
      if check_ct?(@pid, key_ct)
        mail_boxcode_helper(@pid, key_ct)
        flash[:notice] = "Email has been sent with new Box Code"
        redirect_to :action => :page2
      else
        flash.now[:alert] = "Incorrect Challenge Graphic! Please try again"
      end
    else
      flash[:alert] = "Please enter Challenge Graphic!"
    end
  end

  def page2
    @pid = session[:login]
    @option = SscBank.find_by profile_id: @pid
    @ao = @option.auth_option_id
    @a = AuthOption.find_by id: @ao
    if params[:ssc].present? 
      @ssc = params[:ssc].tr(' ','')
      if @ssc.length!=0 
        begin
          @sscVal = SscBank.find_by profile_id: @pid
          if @sscVal.ssc != @ssc || @sscVal[:expiry] < Time.now # ssc mismatched or expired
            flash.now[:notice] = "Invalid SSC" 
            raise "ssc mismatch"
          else
            session[:opt] = 4 # 4. ssc entered.
            redirect_to :action => :view
          end
        rescue 
          flash.now[:notice] = "Invalid SSC" 
        end
      end
    end
  end
  def view
    # 1. ssc is setup
    # 2. ssc is updated
    session[:pid] = nil

    # 3. profile is updated
    # 4. ssc entered. 
  end
  def page3
  end

  def update
    #profile_params.permit!
    params[:profile][:basic_info].permit!
    params[:profile][:address_info].permit!
    params[:profile][:ssc_bank].permit!
    @same_ssc = ((@ssc_bank.auth_value).to_s == (params[:profile][:ssc_bank][:auth_value]).to_s) && ((@ssc_bank.auth_option_id).to_s == (params[:profile][:ssc_bank][:auth_option_id]).to_s) 
    @ssn_selected = (params[:profile][:ssc_bank][:auth_option_id]).to_s == (1).to_s #((AuthOption.find_by :name => 'SSN').id).to_s
    @phn_selected =  (params[:profile][:ssc_bank][:auth_option_id]).to_s == (2).to_s
    respond_to do |format|
      if @profile.update_attributes!(profile_params) &&  @basic_info.update_attributes!(params[:profile][:basic_info]) &&  @address_info.update_attributes!(params[:profile][:address_info]) && @ssc_bank.update_attributes!(params[:profile][:ssc_bank])
        @ssc_bank.update_attributes!(auth_value: @basic_info.ssn) if @ssn_selected
        @ssc_bank.update_attributes!(auth_value: @profile.phone_number) if @phn_selected
        if !@same_ssc
          session[:pid] = @profile.id
          session[:opt] = 2 # 2. ssc is updated
          format.html {redirect_to :controller => :setup, :action => :page3, notice: "update ssc"}
        else
          session[:opt] = 3 # 3. profile is updated
          format.html {redirect_to :action => :view, notice: 'profile saved'}
        end
      else
        format.html {render :action => :page3}
      end
    end
  end

  def forgot_pass
    @profile = Profile.find_by email: params[:email_addr]

  end

  def forgot_pass2
    @profile = Profile.find_by email: params[:email_addr]
    if @profile
      @pass =  set_temp_password
      p = @profile
      p.password = @pass
      p.password_confirmation = @pass
      p.save
      SscMailer.forgot_pass(@profile, @pass).deliver
      flash[:notice] = "A new password has been sent! Please check your email for your new password."
      redirect_to :action => :page1
    else
      flash.now[:notice] = "The email you entered is not registered!"
      render :forgot_pass
    end
  end


  def reset_password
    @profile = Profile.find session[:login]
    if(params[:password])
      p = @profile
      p.password = params[:password]
      p.password_confirmation = params[:password_confirmation]
      p.updating_password = true
      if (p.valid?)
        p.save
        flash[:notice] = "Password successfully updated."
        redirect_to :action => :page3
      else
        flash[:notice] = "Password needds to be 6 charecters and must have an uppercase, lowercase, and number."
      end
    end
  end

  private
  def check_session
    if !session[:login]
      flash[:alert] = "Session expired. Please login again!"
      redirect_to :controller => :home, :action => :index
    end
  end

  def set_values
    # session[:login] = 1 # for debugging. 
    @pid = session[:login]
    @profile = Profile.find(@pid)
    @basic_info = BasicInfo.find_by profile_id: @pid
    @address_info = AddressInfo.find_by profile_id: @pid
    @ssc_bank = SscBank.find_by profile_id: @pid
    @ssn = @basic_info.ssn
    @phn = @profile.phone_number
  end

  def profile_params
    params.require(:profile).permit(:email, :phone_number, :home_phone_number, :carrier_id, basic_info_attributes: [:first_name, :middle_name, :last_name, :dob, :ssn], address_info_attributes: [:street_addr, :apartment_no, :city, :state, :zip_code, :country], ssc_bank_attributes: [ :auth_option_id, :ssc, :ct_mask, :auth_value, :expiry, :lifetime_id])
  end

end
