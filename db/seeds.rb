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

delete_account   = Privilege.create!(sys_name: 'DeleteAccount',     name: 'Delete Account')

# Application
user_manager    = Application.create!(sys_name: 'UserManager',      sys_department: 'system')
account_manager = Application.create!(sys_name: 'AccountManager',   sys_department: 'system')

# Resources
users_post      = Resource.create!(sys_name: 'users.create')
users_get       = Resource.create!(sys_name: 'users.index')
users_passive   = Resource.create!(sys_name: 'users.passive')
users_active    = Resource.create!(sys_name: 'users.active')

accounts_delete = Resource.create!(sys_name: 'tenants.destroy')

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

delete_account.applications << account_manager
delete_account.resources    << accounts_delete
delete_account.save

# Tenants
tenant_lab2023 = Tenant.create!(name: 'lab2023 Inc.', host: 'lab2023.kebab.local')
Tenant.current = tenant_lab2023

# Roles
admin_role  = Role.create!(name: 'Admin')
user_role   = Role.create!(name: 'User')

# Role Privileges
admin_role.privileges << invite_user
admin_role.privileges << delete_account
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
subscription_lab2023 = Subscription.create!(plan_id: 1, tenant_id: 1, user_id: 1, price: 0, payment_period: 1, next_payment_date: Time.zone.now + 1.months)