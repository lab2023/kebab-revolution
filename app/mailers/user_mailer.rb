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
  def forget_password user
    I18n.locale = user.locale
    @user = user
    @new_password = user.password
    mail(to: @user.email, subject: "Forget Password")
  end

  # Public: Send feedback
  #
  # subject - string
  # body    - text
  # user    - object - User Model
  def send_feedback  user, subject, message
    I18n.locale = user.locale
    @user   = user
    @message = message
    # KBBTODO add application email address
    mail(to: "onur.ozgur.ozkan@lab2023.com", subject: "#{@user.name}" + " " + subject)
  end

  # Public: Invite
  #
  # user    - object - User Model
  def invite  user
    I18n.locale = user.locale
    @user   = user
    mail(to: @user.email, subject: 'Welcome to Kebab Project')
  end
end