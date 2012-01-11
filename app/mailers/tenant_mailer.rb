# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Mailer
class TenantMailer < ActionMailer::Base
  default from: "onur.ozgur.ozkan@lab2023.com"

  # Public: Create new tenant mail
  #
  # tenant        - tenant object instance of TenantModel
  # user          - user   object instance of UserModel
  # subscription  - subscription object instance of Subscription
  def create_tenant user, tenant, subscription
    @user         = user
    @tenant       = tenant
    @subscription = subscription
    # KBBTODO add i18n
    mail(:to => user.email, :subject => "Welcome Kebab Project")
  end
end
