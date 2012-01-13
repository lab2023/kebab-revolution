# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Model
class Tenant < ActiveRecord::Base
  has_one     :subscription
  has_many    :users
  has_many    :roles

  validates :name, :presence => {:on => :create}, :uniqueness => true, :length => {:in => 4..255}
  validates :host, :presence => {:on => :create}, :uniqueness => true, :exclusion => {:in => %w(www help support api apps status blog lab2023 static)}, :length => {:in => 4..255}

  scope :active,  where("passive_at IS NULL")
  scope :passive, where("passive_at IS NOT NULL")

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

  def with
    previous, Tenant.current = Tenant.current, self
    yield
  ensure
    Tenant.current = previous
  end
end
