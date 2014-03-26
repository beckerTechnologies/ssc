class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'
  

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @ct = ct
    mail(to: @profile.email, subject: 'New Challange Text')
    sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)
    sms_fu.deliver(@profile.phone_number,"verizon","message") # TODO change the carrier to dynamic selection
  end

 
end
