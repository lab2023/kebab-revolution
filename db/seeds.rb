Tenant.create([
                  {name: 'Apple Inc.', host: 'apple.kebab.local', owner_id: 1},
                  {name: 'lab2023 Inc.', host: 'lab2023.kebab.local', owner_id: 3}
              ])

Role.create([
                {name: 'Ceo',  tenant_id: 1},
                {name: 'Manager',  tenant_id: 1},
                {name: 'Engineer', tenant_id: 1},
                {name: 'Ceo', tenant_id: 2},
                {name: 'Backend Developer',  tenant_id: 2},
                {name: 'Frontend Developer',  tenant_id: 2}
            ])

User.create([
                {name: 'Steve Jobs', email: 'steve@jobs.com', password: '123456', password_confirmation: '123456', locale: 'tr', tenant_id: 1},
                {name: 'Steve Wozniak', email: 'steve@wozniak.com', password: '123456', password_confirmation: '123456', locale: 'tr',  tenant_id: 1},
                {name: 'Onur Ozgur OZKAN', email: 'onur@ozgur.com', password: '123456', password_confirmation: '123456',  locale: 'tr', tenant_id: 2},
                {name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', locale: 'tr', tenant_id: 2}
            ])

Privilege.create([
                     {sys_name: 'changePassword', name: 'Change Password'},
                     {sys_name: 'cancelAccount', name: 'Cancel Account'}
                 ])

cancel_account = Privilege.find_by_sys_name('cancelAccount')
change_password = Privilege.find_by_sys_name('changePassword')

Tenant.current = Tenant.find_by_host('apple.kebab.local')

ceo = Role.find_by_name('Ceo')
manager = Role.find_by_name('Manager')
engineer = Role.find_by_name('Engineer')

steve = User.find_by_name('Steve Jobs')
steve.roles << ceo
steve.roles << manager
steve.save

wozniak = User.find_by_name('Steve Wozniak')
wozniak.roles << engineer
wozniak.save

ceo.privileges << cancel_account
ceo.privileges << change_password
manager.privileges << change_password
engineer.privileges << change_password

ceo.save
manager.save
engineer.save

Tenant.current = Tenant.find_by_host('lab2023.kebab.local')
ceo = Role.find_by_name('Ceo')
backend = Role.find_by_name('Backend Developer')
frontend = Role.find_by_name('Frontend Developer')

onur = User.find_by_name('Onur Ozgur OZKAN')
onur.roles << ceo
onur.roles << backend
onur.save

tayfun = User.find_by_name('Tayfun Ozis ERIKAN')
tayfun.roles << ceo
tayfun.roles << frontend
tayfun.save

ceo.privileges << cancel_account
ceo.privileges << change_password
backend.privileges << change_password
frontend.privileges << change_password

ceo.save
backend.save
frontend.save

App.create([
               {sys_name: 'profile', sys_department: 'system'},
               {sys_name: 'accountManager', sys_department: 'system'}
           ])

profile = App.find_by_sys_name('profile')
profile.privileges << change_password
profile.save

account_manager = App.find_by_sys_name('accountManager')
account_manager.privileges << cancel_account
account_manager.save

Resource.create([
               {sys_path: 'POST/passwords',  sys_name: 'passwords/create'},
               {sys_path: 'POST/sessions',   sys_name: 'sessions/create'},
               {sys_path: 'DELETE/sessions', sys_name: 'sessions/destroy'}
           ])

change_password.resources << Resource.find_by_sys_name('passwords/create')
change_password.save
