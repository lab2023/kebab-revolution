require "kebab"

Kebab.configure do |config|
  config.application_name = "Kebab Project"
  config.application_url = "kebab.local"
  config.invoice_no = "108536" #must be integer
  config.invalid_tenant_names = %w(www help support api apps status blog lab2023 static)
end