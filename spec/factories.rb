Factory.define :tenant do |f|
  f.sequence(:name) { |n| "name-#{n}" }
  f.sequence(:host) { |n| "name-#{n}.kebab-server-ror.com" }
end

Factory.define :user do |f|
  f.sequence(:email) { |n| "test-#{n}@test.com" }
  f.password 'password'
  f.password_confirmation 'password'
  f.sequence(:name) { |n|  "Name#{n} Surname#{n}" }
  f.tenant {|a| a.association(:tenant) }
end