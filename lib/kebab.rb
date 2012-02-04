# KBBTODO rdoc
# KBBTODO test
# Kebab Module
module Kebab
 class << self
   attr_accessor :application_name
   attr_accessor :application_url
   attr_accessor :application_email
   attr_accessor :invoice_no
   attr_accessor :invalid_tenant_names
 end

 # Configure
 def self.configure(&block)
   yield Kebab
 end
end