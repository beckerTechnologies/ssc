class SscMailer < ActionMailer::Base
  default from: 'notifications.ssc@gmail.com'

  def newct_email(user, ct)
    @user = user
    @profile = Profile.find(@user)
    @basic_info = BasicInfo.find_by profile_id: @user
    @ct = ct
    mail(to: @profile.email, subject: 'New Challange Text')
  end
end
