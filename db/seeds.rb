# Plans
Plan.create!(:name => "Free",     :price => 0,   :user_limit => 1,     :recommended => false)
Plan.create!(:name => "Basic",    :price => 99,  :user_limit => 4,     :recommended => false)
Plan.create!(:name => "Plus",     :price => 299, :user_limit => 12,    :recommended => true)
Plan.create!(:name => "Premium",  :price => 499, :user_limit => 24,    :recommended => false)
Plan.create!(:name => "Max",      :price => 999, :user_limit => 9999,  :recommended => false)

# Privileges
Privilege.create!(sys_name: 'changePassword', name: 'Change Password')
Privilege.create!(sys_name: 'cancelAccount', name: 'Cancel Account')

# Apps
App.create!(sys_name: 'profile', sys_department: 'system')
App.create!(sys_name: 'accountManager', sys_department: 'system')

# Resources
Resource.create!(sys_path: 'POST/passwords',  sys_name: 'passwords/create')
Resource.create!(sys_path: 'POST/sessions',   sys_name: 'sessions/create')
Resource.create!(sys_path: 'DELETE/sessions', sys_name: 'sessions/destroy')

# Tenants
Tenant.create!(name: 'lab2023 Inc.', host: 'lab2023.kebab.local')
Tenant.current = Tenant.find_by_host('lab2023.kebab.local')

# Roles
Role.create!(name: 'admin')
Role.create!(name: 'user')

# Users
User.create!(name: 'Onur Ozgur OZKAN', email: 'onur@ozgur.com', password: '123456', password_confirmation: '123456',  locale: 'tr')
User.create!(name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'tr')

cancel_account  = Privilege.find_by_sys_name('cancelAccount')
change_password = Privilege.find_by_sys_name('changePassword')

admin = Role.find_by_name('admin')
user = Role.find_by_name('user')

onur = User.find_by_name('Onur Ozgur OZKAN')
onur.roles << admin
onur.roles << user
onur.save

tayfun = User.find_by_name('Tayfun Ozis ERIKAN')
tayfun.roles << admin
tayfun.save

admin.privileges << cancel_account
admin.privileges << change_password
user.privileges << change_password

admin.save
user.save

profile = App.find_by_sys_name('profile')
profile.privileges << change_password
profile.save

account_manager = App.find_by_sys_name('accountManager')
account_manager.privileges << cancel_account
account_manager.save

change_password.resources << Resource.find_by_sys_name('passwords/create')
change_password.save
