# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# User Mailer
class UserMailer < ActionMailer::Base
  default from: "example@example.com"

  # Public: Send forget password mail
  #
  # user - user object instance of UserModel
  def forget_password(user)
    @user = user
    @new_password = user.password
    mail(:to => @user.email, :subject => "Forget Password")
  end
end