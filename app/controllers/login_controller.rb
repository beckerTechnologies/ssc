class LoginController < ApplicationController
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
              raise "ssc mismatch"
            else
              redirect_to :action => :page3
            end
          rescue 
            flash[:notice] = "incorrect or expired SSC. use the button below to send yourself a new CT." 
          end
        end
      else
        flash.clear
      end
    end
  end
  def page3
    @pid = session[:login]
    @profile = Profile.find(@pid)
    @basic_info = BasicInfo.find_by profile_id: @pid
    @ssc_bank = SscBank.find_by profile_id: @pid
    @ca = Carrier.all
    @ao = AuthOption.all
    @lt = Lifetime.all
    render :action => :editprofile
  end
  def update
    @ca = Carrier.all
    @ao = AuthOption.all
    @lt = Lifetime.all
    profile_params.permit!
    @profile = Profile.new(profile_params)
    #params[:profile].permit!
    #@profile = Profile.new(params[:profile])
    params[:profile][:basic_info].permit!
    @basic_info = BasicInfo.new(params[:profile][:basic_info])
    params[:profile][:ssc_bank].permit!
    @ssc_bank = SscBank.new(params[:profile][:ssc_bank])

    @profile.valid? 
    @basic_info.valid?
    @ssc_bank.valid?

    if @profile.errors.present? || @basic_info.errors.present? || @ssc_bank.errors.present?
      flash[:notice] = "#{@profile.errors.full_messages.to_sentence} - #{@basic_info.errors.full_messages.to_sentence} - #{@ssc_bank.errors.full_messages.to_sentence}" 
      render :action => :editprofile
    else
      @profile.save!
      @basic_info[:profile_id] = @profile[:id]
      @basic_info.save!
      @ssc_bank[:profile_id] = @profile[:id]
      @ssc_bank.save!
      flash[:notice] = "saved with id: #{@profile[:id]}"
      render :action => :editprofile
    end
  end

  def profile_params
    params.require(:profile).permit(:email, :password, :password_confirmation, :phone_number, :street_addr, :apartment_no, :city, :state, :zip_code, :country, :carrier_id, basic_info_attributes: [:id, :first_name, :middle_name, :last_name, :dob, :ssn], ssc_bank_attributes: [:id, :auth_option_id, :ssc, :ct_mask, :auth_value, :expiry, :lifetime_id])
  end

end
