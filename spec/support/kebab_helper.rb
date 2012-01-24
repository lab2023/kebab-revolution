module KebabHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def valid_tenant_host
    "lab2023.#{Kebab.application_url.to_s}"
  end

  def invalid_tenant_host
    "invalid.#{Kebab.application_url.to_s}"
  end
end

RSpec.configure do |c|
  c.include KebabHelper
end