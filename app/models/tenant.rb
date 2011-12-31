# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Model
class Tenant < ActiveRecord::Base
  has_many    :users
  has_many    :roles
  belongs_to  :owner, :class_name => "User", :foreign_key => :owner_id

  validates :name, :presence => {:on => :create},
                   :uniqueness => true,
                   :length => {:in => 4..255}

  validates :host, :presence => {:on => :create},
                   :uniqueness => true,
                   :exclusion => {:in => %w(www help support api apps status blog lab2023)},
                   :length => {:in => 4..255}

  class << self
    # Public: Return current tenant
    def current
      Thread.current[:tenant]
    end

    # Public: Set current tenant
    def current=(tenant)
      Thread.current[:tenant] = tenant
    end
  end

end
