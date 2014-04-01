class LoginController < ApplicationController
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
    #params[:profile][:basic_info].permit!
    #params[:profile][:ssc_bank].permit!
    #@pro = Profile.new(id:100, email:'237824@fhjkfhw.frhekugferu')

    respond_to do |format|
      if @profile.update_attributes!(profile_params) #@profile.update(profile_params)
        format.html {render :action => :page3, notice: 'profile saved'}
      else 
        format.html {render :action => :page3}
      end
    end
=begin
      @basic_info.update(params[:profile][:basic_info])
      @ssc_bank.update(params[:profile][:ssc_bank])
      flash[:notice] = "saved with id: #{@profile[:id]}"
      render :action => :page3
=end
  end
  private
  def set_values
    session[:login] =1
    @ca = Carrier.all
    @ao = AuthOption.all
    @lt = Lifetime.all
    @pid = session[:login]
    @profile = Profile.find(@pid)
    @basic_info = BasicInfo.find_by profile_id: @pid
    @ssc_bank = SscBank.find_by profile_id: @pid
  end

  def profile_params
  params.require(:profile).permit(:email, :password, :password_confirmation, :phone_number, :street_addr, :apartment_no, :city, :state, :zip_code, :country, :carrier_id, basic_info_attributes: [:first_name, :middle_name, :last_name, :dob, :ssn], ssc_bank_attributes: [ :auth_option_id, :ssc, :ct_mask, :auth_value, :expiry, :lifetime_id])
  end

end
