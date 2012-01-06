# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Mailer
class TenantMailer < ActionMailer::Base
  default from: "from@example.com"

  # Public: Create new tenant mail
  #
  # tenant        - tenant object instance of TenantModel
  # user          - user   object instance of UserModel
  # subscription  - subscription object instance of Subscription
  def create_tenant tenant, user, subscription
    @subscription = subscription
    @tenant       = tenant
    @user         = user
    # KBBTODO add i18n
    mail(:to => @user.email, :subject => "Welcome Kebab Project")
  end
end
