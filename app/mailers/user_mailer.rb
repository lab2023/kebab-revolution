# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# User Mailer
class UserMailer < ActionMailer::Base
  layout 'email'
  default from: "onur.ozgur.ozkan@lab2023.com"

  # Public: Send forget password mail
  #
  # user - user object instance of UserModel
  def forget_password user
    I18n.locale = user.locale
    @user = user
    @new_password = user.password
    @application_name = Kebab.application_name
    mail(to: @user.email, subject: I18n.t('mail.subjects.forget_password', :application_name => Kebab.application_name))
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
    mail(to: "onur.ozgur.ozkan@lab2023.com", subject: "#{@user.name}" + " " + subject)
  end

  # Public: Invite
  #
  # user - object - User Model
  def invite user, tenant_host
    I18n.locale = user.locale
    @user   = user
    @application_url = "http://" + tenant_host.to_s
    mail(to: @user.email, subject: I18n.t('mail.subjects.invite_user', :application_name => Kebab.application_name))
  end
end