class User < TenantScopedModel
  has_secure_password

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email,     :presence => {:on => :create},
                        :uniqueness => true,
                        :format => {:with => EMAIL_REGEX}

  validates :password,  :presence => {:on => :create},
                        :confirmation => true

  validates :password_confirmation, :presence => true

  validates :name, :presence => true

  validates :tenant, :presence => true
end