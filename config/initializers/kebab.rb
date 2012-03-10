# encoding: utf-8
require "kebab"
Kebab.configure do |config|
  config.application_name = "Kebab Project"
  config.application_version = "0.0.1"
  config.application_url = (Rails.env == 'production' ? "kebab-project.com" : "kebab-project.local")
  config.application_email = "info@kebab-project.com"
  config.application_support_email = "support@kebab-project.com"
  config.blowfish_password = "blowfish-change-this"
  config.invoice_no = "108536" #must be integer
  config.invalid_tenant_names = %w(www help support api apps status blog static dev shop market media tv video story changelog mail db report admin addons owner billing)
end
