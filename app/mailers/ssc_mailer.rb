class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'
  

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @ssc = SscBank.find_by profile_id: @user
    @lifetime_id = @ssc.lifetime_id
    @lifetime = Lifetime.find_by id: @lifetime_id
    @ct = ct
    mail(to: @profile.email, subject: 'New Plus-One Challenge Symbol')

    if @profile.carrier_id != nil
      @carrier_id = @profile.carrier_id
      @carrier = Carrier.find(@carrier_id)
      easy = SMSEasy::Client.new
      easy.deliver(@profile.phone_number, @carrier.carrier_value, "Thank you for using Plus-One! Your CS is #{@ct}. This expires in #{@lifetime.hours} hours.")
    end
    
  end
  def newbox_email(user, boxcode)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @ssc = SscBank.find_by profile_id: @user
    @lifetime_id = @ssc.lifetime_id
    @lifetime = Lifetime.find_by id: @lifetime_id
    @boxcode = boxcode
    mail(to: @profile.email, subject: 'New Plus-One Box Code')
  end

  def forgot_pass(profile, pass)
    @profile = profile
    @basic_info = BasicInfo.find_by profile_id: @profile
    @pass = pass
    mail(to: @profile.email, subject: 'New Plus-One Website Password')
  end
end



