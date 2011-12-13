module KebabHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def valid_tenant_host
    'tenant1.kebab-server-ror.local'
  end

  def invalid_tenant_host
    'invalid.kebab-server-ror.local'
  end
end

RSpec.configure do |c|
  c.include KebabHelper
end