# Plans
free_plan     = Plan.create!(:name => "Free",    :price => 0,   :user_limit => 1,    :recommended => false)
basic_plan    = Plan.create!(:name => "Basic",   :price => 99,  :user_limit => 4,    :recommended => false)
plus_plan     = Plan.create!(:name => "Plus",    :price => 299, :user_limit => 12,   :recommended => true)
premium_plan  = Plan.create!(:name => "Premium", :price => 499, :user_limit => 24,   :recommended => false)
max_plan      = Plan.create!(:name => "Max",     :price => 999, :user_limit => 9999, :recommended => false)

# Privileges
invite_user     = Privilege.create!(sys_name: 'InviteUser',       name: 'Invite User')

# Application
user_manager    = Application.create!(sys_name: 'UserManager',    sys_department: 'system')

# Resources
post_users      = Resource.create!(sys_path: 'POST/users',  sys_name: 'users/create')
get_users       = Resource.create!(sys_path: 'GET/users',   sys_name: 'users/index')

# Apps Resource Privileges Relation
invite_user.applications << user_manager
invite_user.resources << post_users
invite_user.resources << get_users
invite_user.save

# Tenants
tenant_lab2023 = Tenant.create!(name: 'lab2023 Inc.', host: 'lab2023.kebab.local')
Tenant.current = tenant_lab2023

# Roles
admin_role  = Role.create!(name: 'Admin')
user_role   = Role.create!(name: 'User')

# Role Privileges
admin_role.privileges << invite_user
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