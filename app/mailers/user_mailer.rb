class UserMailer < ActionMailer::Base
  default from: "jieshuquan@gmail.com"

  def find_password_for_user(user)
    @user = user
    mail(to: @user.email, subject: '您的借书圈app的密码')
  end
end
