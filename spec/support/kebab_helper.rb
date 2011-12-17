module KebabHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def valid_tenant_host
    'tenant1.server-ror.dev'
  end

  def invalid_tenant_host
    'invalid.server-ror.dev'
  end
end

RSpec.configure do |c|
  c.include KebabHelper
end