source 'http://rubygems.org'

gem 'rails', '3.1.3'
#gem 'rails', '3.2.1'

gem 'mysql2'

gem 'globalize3'

# To use ActiveModel HAS_SECURE_PASSWORD
gem 'bcrypt-ruby', '~> 3.0.0'

# Paypal Gem
gem "paypal-recurring", :git => "git@github.com:onurozgurozkan/paypal-recurring.git", :branch => "master"

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
group :development do
  gem 'capistrano'
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem 'factory_girl_rails'
  gem "rspec-rails", :group => [:test, :development]
end
