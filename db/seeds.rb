# Plans
free_plan     = Plan.create!(:name => "Free",    :price => 0,   :user_limit => 1,    :recommended => false)
basic_plan    = Plan.create!(:name => "Basic",   :price => 99,  :user_limit => 4,    :recommended => false)
plus_plan     = Plan.create!(:name => "Plus",    :price => 299, :user_limit => 12,   :recommended => true)
premium_plan  = Plan.create!(:name => "Premium", :price => 499, :user_limit => 24,   :recommended => false)
max_plan      = Plan.create!(:name => "Max",     :price => 999, :user_limit => 9999, :recommended => false)

# Privileges
cancel_account     = Privilege.create!(sys_name: 'CancelAccount',    name: 'Cancel Account')
invite_user        = Privilege.create!(sys_name: 'InviteUser',       name: 'Invite User')
update_user_status = Privilege.create!(sys_name: 'UpdateUserStatus', name: 'Update User Status')

# Application
account_manager = Application.create!(sys_name: 'AccountManager', sys_department: 'system')
user_manager    = Application.create!(sys_name: 'UserManager',    sys_department: 'system')

# Resources
delete_tenants   = Resource.create!(sys_path: 'DELETE/tenants',  sys_name: 'tenants/destroy')
post_users       = Resource.create!(sys_path: 'POST/users',      sys_name: 'users/create')
put_users        = Resource.create!(sys_path: 'PUT/users',       sys_name: 'users/update')

# Apps Resource Privileges Relation
cancel_account.applications << account_manager
cancel_account.resources << delete_tenants
cancel_account.save

invite_user.applications << user_manager
invite_user.resources << post_users
invite_user.save

update_user_status.applications << user_manager
update_user_status.resources << put_users
update_user_status.save

# Tenants
tenant_lab2023 = Tenant.create!(name: 'lab2023 Inc.', host: 'lab2023.kebab.local')
Tenant.current = tenant_lab2023

# Roles
admin_role  = Role.create!(name: 'Admin')
user_role   = Role.create!(name: 'User')

# Users
onur    = User.create!(name: 'Onur Ozgur OZKAN',   email: 'onur@ozgur.com',  password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')
tayfun  = User.create!(name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'tr', time_zone: 'Istanbul')


# User Role Relation
onur.roles << admin_role
onur.roles << user_role
onur.save

tayfun.roles << user_role
tayfun.save