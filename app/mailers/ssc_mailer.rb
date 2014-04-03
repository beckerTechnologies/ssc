class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'
  

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @ssc = SscBank.find_by profile_id: @user
    @lifetime_id = @ssc.lifetime_id
    @lifetime = Lifetime.find_by id: @lifetime_id
    @carrier_id = @profile.carrier_id
    @carrier = Carrier.find(@carrier_id)
    @ct = ct
    mail(to: @profile.email, subject: 'New Plus-One Challenge Symbol')
    easy = SMSEasy::Client.new
    easy.deliver(@profile.phone_number, @carrier.carrier_value, "Thank you for using Plus-One! Your CS is #{@ct}. This expires in #{@lifetime.hours} hours.")
  end

  def forgot_pass(profile)
    @profile = profile
    @basic_info = BasicInfo.find_by profile_id: @profile
    mail(to: @profile.email, subject: 'New Plus-One Website Password')
  end
end



