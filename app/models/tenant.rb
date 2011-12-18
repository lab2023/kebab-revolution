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
    def current
      Thread.current[:tenant]
    end

    def current=(tenant)
      Thread.current[:tenant] = tenant
    end
  end

end
