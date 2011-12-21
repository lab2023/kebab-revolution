Factory.define :tenant do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.sequence(:host) { |n| "name-#{n}.server-ror.dev" }
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "test-#{n}@test.com" }
  f.password 'password'
  f.password_confirmation 'password'
  f.locale 'tr'
  f.sequence(:name) { |n|  "Name#{n} Surname#{n}" }
  f.tenant {|a| a.association(:tenant) }
end

Factory.define :privilege do |f|
  f.sys_name 'addNewUser'
  f.name     'Add New User'
  f.info     'Can add a new user'
end