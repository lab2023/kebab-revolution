class Tenant < ActiveRecord::Base
  validates :name, :presence => {:on => :create},
                   :uniqueness => true,
                   :length => {:in => 4..255}

  validates :host, :presence => {:on => :create},
                   :uniqueness => true,
                   :exclusion => {:in => %w(www lab2023)},
                   :length => {:in => 4..255}

  class << self
    def current
      Thread.current[:current_tenant]
    end

    def current=(tenant)
      Thread.current[:current_tenant] = tenant
    end
  end
end
