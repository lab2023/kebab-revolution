# Tenant for test and development
tenant = Tenant.create([
                           {name: 'Apple Inc.', host: 'apple.server-ror.dev'},
                           {name: 'lab2023 Inc.', host: 'lab2023.server-ror.dev'}
                       ])

role = Role.create([
                       {name: 'Ceo',  tenant_id: 1},
                       {name: 'Manager',  tenant_id: 1},
                       {name: 'Engineer', tenant_id: 1},
                       {name: 'Ceo', tenant_id: 2},
                       {name: 'Backend Developer',  tenant_id: 2},
                       {name: 'Frontend Developer',  tenant_id: 2}
                   ])

user = User.create([
                       {name: 'Steve Jobs', email: 'steve@jobs.com', password: '123456', password_confirmation: '123456', tenant_id: 1},
                       {name: 'Steve Wozniak', email: 'steve@wozniak.com', password: '123456', password_confirmation: '123456', tenant_id: 1},
                       {name: 'Onur Ozgur OZKAN', email: 'onur@ozgur.com', password: '123456', password_confirmation: '123456', tenant_id: 2},
                       {name: 'Tayfun Ozis ERIKAN', email: 'tayfun@ozis.com', password: '123456', password_confirmation: '123456', tenant_id: 2}
                   ])

Tenant.current = Tenant.find_by_host('apple.server-ror.dev')
steve = User.find_by_name('Steve Jobs')
steve.roles << Role.find_by_name('Ceo')
steve.roles << Role.find_by_name('Manager')
steve.save

wozniak = User.find_by_name('Steve Wozniak')
wozniak.roles << Role.find_by_name('Engineer')
wozniak.save

Tenant.current = Tenant.find_by_host('lab2023.server-ror.dev')
onur = User.find_by_name('Onur Ozgur OZKAN')
onur.roles << Role.find_by_name('Ceo')
onur.roles << Role.find_by_name('Backend Developer')
onur.save

tayfun = User.find_by_name('Tayfun Ozis ERIKAN')
tayfun.roles << Role.find_by_name('Ceo')
tayfun.roles << Role.find_by_name('Frontend Developer')
tayfun.save
