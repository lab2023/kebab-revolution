Factory.define :tenant do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.sequence(:subdomain) { |n| "name-#{n}.#{Kebab.application_url.to_s}" }
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "test-#{n}@test.com" }
  f.password 'password'
  f.password_confirmation 'password'
  f.locale 'tr'
  f.time_zone 'Istanbul'
  f.sequence(:name) { |n|  "Name#{n} Surname#{n}" }
  f.tenant {|a| a.association(:tenant) }
  f.passive_at 'nil'
end

Factory.define :privilege do |f|
  f.sys_name 'addNewUser'
  f.name     'Add New User'
  f.info     'Can add a new user'
end

Factory.define :resource do |f|
  f.sequence(:sys_path) { |n| "GET/controller#{n}/action#{n}" }
  f.sequence(:sys_name) { |n| "controller#{n}.action#{n}" }
end