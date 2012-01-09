module KebabHelper
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def valid_tenant_host
    'lab2023.kebab.local'
  end

  def invalid_tenant_host
    'invalid.kebab.local'
  end
end

RSpec.configure do |c|
  c.include KebabHelper
end