# KBBTODO rdoc
# KBBTODO test
# Kebab Module
module Kebab
 class << self
   attr_accessor :application_name
   attr_accessor :application_url
   attr_accessor :invoice_no
 end

 # Configure
 def self.configure(&block)
   yield Kebab
 end
end