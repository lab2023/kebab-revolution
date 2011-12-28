class UserMailer < ActionMailer::Base
  default from: "example@example.com"

  def forget_password(user)
    @user = user
    @new_password = user.password
    mail(:to => @user.email, :subject => "Forget Password")
  end
end