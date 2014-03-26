class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'
  

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @carrier_id = @profile.carrier_id
    @carrier = Carrier.find(@carrier_id)
    @ct = ct
    mail(to: @profile.email, subject: 'New Challange Text')
    
    easy = SMSEasy::Client.new
    easy.deliver(@profile.phone_number, @carrier.carrier_value, "Your Chanllenge Text is: #{@ct}")
  end

 
end
