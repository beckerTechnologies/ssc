class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'
  

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @carrier_id = @profile.carrier_id
    @ct = ct
    mail(to: @profile.email, subject: 'New Challange Text')
    # sms_fu = SMSFu::Client.configure(:delivery => :action_mailer)
    # sms_fu.deliver("8576006750","verizon","message") # TODO change the carrier to dynamic selection

    easy = SMSEasy::Client.new
    easy.deliver("8576006750", "verizon", "message")
  end

 
end
