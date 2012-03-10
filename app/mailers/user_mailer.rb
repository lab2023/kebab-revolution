# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# User Mailer
class UserMailer < ActionMailer::Base
  layout 'email'
  default from: "Kebab Dev Team <no-reply@kebab-project.com>"

  # Public: Send forget password mail
  #
  # user - user object instance of UserModel
  def forget_password user
    I18n.locale = user.locale
    @user = user
    @new_password = user.password
    @application_name = Kebab.application_name
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: I18n.t('mail.subjects.forget_password', :application_name => Kebab.application_name))
  end

  # Public: Invite
  #
  # user - object - User Model
  def invite user, subdomain
    I18n.locale = user.locale
    @user   = user
    @application_url = "http://" + subdomain.to_s + "." + Kebab.application_url.to_s
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: I18n.t('mail.subjects.invite_user', :application_name => Kebab.application_name))
  end

  def enable user
    I18n.locale = user.locale
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: I18n.t('mail.subjects.enable_user', :application_name => Kebab.application_name))
  end

  def disable user
    I18n.locale = user.locale
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(to: email_with_name, subject: I18n.t('mail.subjects.disable_user', :application_name => Kebab.application_name))
  end
end