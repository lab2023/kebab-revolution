class Tenant < ActiveRecord::Base
  has_many :users

  validates :name, :presence => {:on => :create},
                   :uniqueness => true,
                   :length => {:in => 4..255}

  validates :host, :presence => {:on => :create},
                   :uniqueness => true,
                   :exclusion => {:in => %w(www help support api apps status blog lab2023 coninja)},
                   :length => {:in => 4..255}

  class << self
    def current
      Thread.current[:tenant]
    end

    def current=(tenant)
      Thread.current[:tenant] = tenant
    end
  end

  validates :name, :host, presence: true
end
