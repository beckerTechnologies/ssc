class LoginController < ApplicationController
  before_action :check_session, except: [:page1]
  before_action :set_values, only: [:page3, :update]
  layout 'login'  
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
            redirect_to :action => :page2
          end
        rescue 
          flash[:notice] = "Incorrect username or password."
        end
      end
    else
      flash.clear
    end
  end

  def page2
    if !session[:login]
      redirect_to :action => :page1
    else
      @pid = session[:login]
      if params[:sendnew].present?
        #RenewWorker.perform_async(@pid)
        mail_helper(@pid)
        flash[:success] = true
      elsif params[:ssc].present? 
        @ssc = params[:ssc].tr(' ','')
        if @ssc.length!=0 
          begin
            @sscVal = SscBank.find_by profile_id: @pid
            if @sscVal.ssc != @ssc || @sscVal[:expiry] < Time.now # ssc mismatched or expired
              flash[:notice] = "incorrect or expired SSC. use the button below to send yourself a new CT.#{@ssc}-#{@sscVal.ssc}-#{@sscVal.expiry}-#{Time.now}" 
              raise "ssc mismatch"
            else
              redirect_to :action => :page3
            end
          rescue 
            flash[:notice] = "incorrect or expired SSC. use the button below to send yourself a new CT.#{@ssc}-#{@sscVal.ssc}-#{@sscVal.expiry}-#{Time.now}" 
          end
        end
      else
        flash.clear
      end
    end
  end
  def page3
  end
  def update
    #profile_params.permit!
    params[:profile][:basic_info].permit!
    params[:profile][:ssc_bank].permit!
    @same_ssc = ((@ssc_bank.auth_value).to_s == (params[:profile][:ssc_bank][:auth_value]).to_s) && ((@ssc_bank.auth_option_id).to_s == (params[:profile][:ssc_bank][:auth_option_id]).to_s) 
    @ssn_selected = (params[:profile][:ssc_bank][:auth_option_id]).to_s == ((AuthOption.find_by :name => 'SSN').id).to_s
    respond_to do |format|
      if @profile.update_attributes!(profile_params) &&  @basic_info.update_attributes!(params[:profile][:basic_info]) && @ssc_bank.update_attributes!(params[:profile][:ssc_bank])
        @ssc_bank.update_attributes!(auth_value: @basic_info.ssn) if @ssn_selected
        if !@same_ssc
          session[:pid] = @profile.id
          format.html {redirect_to :controller => :setup, :action => :page3, notice: "update ssc #{@ssn_selected}"}
        else
          format.html {render :action => :page3, notice: 'profile saved'}
        end
      else
        format.html {render :action => :page3}
      end
    end
  end
  private
  def check_session
    if !session[:login]
      flash[:alert] = "Session expired. Hit return to go back. "
      redirect_to :controller => :home, :action => :index
    end
  end

  def set_values
    # session[:login] = 1 # for debugging. 
    @pid = session[:login]
    @profile = Profile.find(@pid)
    @basic_info = BasicInfo.find_by profile_id: @pid
    @ssc_bank = SscBank.find_by profile_id: @pid
    @ssn = @basic_info.ssn
  end

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation, :phone_number, :street_addr, :apartment_no, :city, :state, :zip_code, :country, :carrier_id, basic_info_attributes: [:first_name, :middle_name, :last_name, :dob, :ssn], ssc_bank_attributes: [ :auth_option_id, :ssc, :ct_mask, :auth_value, :expiry, :lifetime_id])
  end

end
