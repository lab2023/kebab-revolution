# Plans
free_plan     = Plan.create!(:name => "Free",    :price => 0,   :user_limit => 1,    :recommended => false)
basic_plan    = Plan.create!(:name => "Basic",   :price => 99,  :user_limit => 4,    :recommended => false)
plus_plan     = Plan.create!(:name => "Plus",    :price => 299, :user_limit => 12,   :recommended => true)
premium_plan  = Plan.create!(:name => "Premium", :price => 499, :user_limit => 24,   :recommended => false)
max_plan      = Plan.create!(:name => "Max",     :price => 999, :user_limit => 9999, :recommended => false)

# Privileges
invite_user      = Privilege.create!(sys_name: 'InviteUser',        name: 'Invite User')
passive_user     = Privilege.create!(sys_name: 'PassiveUser',       name: 'Passive User')
active_user      = Privilege.create!(sys_name: 'ActiveUser',        name: 'Active User')

manage_account   = Privilege.create!(sys_name: 'ManageAccount',     name: 'Manage Account')

# Application
user_manager    = Application.create!(sys_name: 'UserManager',      sys_department: 'system')
account_manager = Application.create!(sys_name: 'AccountManager',   sys_department: 'system')

# Resources
users_post      = Resource.create!(sys_name: 'users.create')
users_get       = Resource.create!(sys_name: 'users.index')
users_passive   = Resource.create!(sys_name: 'users.passive')
users_active    = Resource.create!(sys_name: 'users.active')

accounts_delete         = Resource.create!(sys_name: 'tenants.destroy')                                # Delete account
paypal_payment_success  = Resource.create!(sys_name: 'subscriptions.paypal_recurring_payment_success') # Paypal success recurring payment return page
paypal_payment_failed   = Resource.create!(sys_name: 'subscriptions.paypal_recurring_payment_failed')  # Paypal failed  recurring payment return page
paypal_credential       = Resource.create!(sys_name: 'subscriptions.paypal_credential')                # Paypal paypal_credential ajax
next_subscription       = Resource.create!(sys_name: 'subscriptions.next_subscription')                # Next subscription
payments                = Resource.create!(sys_name: 'subscriptions.payments')                         # All payments

# Privileges Applications Resources Relation
invite_user.applications << user_manager
invite_user.resources    << users_post
invite_user.resources    << users_get
invite_user.save

passive_user.applications << user_manager
passive_user.resources    << users_passive
passive_user.save

active_user.applications << user_manager
active_user.resources    << users_active
active_user.save

manage_account.applications << account_manager
manage_account.resources    << accounts_delete
manage_account.resources    << paypal_payment_failed
manage_account.resources    << paypal_payment_success
manage_account.resources    << paypal_credential
manage_account.resources    << next_subscription
manage_account.resources    << payments
manage_account.save

# Tenants
tenant_lab2023 = Tenant.create!(name: 'lab2023 Inc.', host: "lab2023.#{Kebab.application_url.to_s}")
Tenant.current = tenant_lab2023

# Roles
admin_role  = Role.create!(name: 'Admin')
user_role   = Role.create!(name: 'User')

# Role Privileges
admin_role.privileges << invite_user
admin_role.privileges << manage_account
admin_role.save

# Users
onur    = User.create!(name: 'Onur Ozgur OZKAN',   email: 'onur@ozgur.com',  password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')
tayfun  = User.create!(name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')


# User Role Relation
onur.roles << admin_role
onur.roles << user_role
onur.save

tayfun.roles << user_role
tayfun.save

# Subscription
plan_2 = Plan.find(2)
subscription_lab2023 = Subscription.create!(plan_id: plan_2.id, tenant_id: 1, user_id: 1, price: plan_2.price, payment_period: 1, next_payment_date: Time.zone.now + 1.months)