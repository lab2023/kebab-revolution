# KBBTODO rdoc
# KBBTODO test
module Kebab
 class << self
   attr_accessor :application_name
 end

 def self.configure(&block)
   yield Kebab
 end
end