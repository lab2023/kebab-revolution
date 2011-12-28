class User < TenantScopedModel
  has_secure_password
  has_and_belongs_to_many :roles

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email,     :presence => {:on => :create},
                        :uniqueness => true,
                        :format => {:with => EMAIL_REGEX}

  validates :name,      :presence => true

  validates :locale,    :presence => true,
                        :inclusion => { :in => %w(en tr ru)},
                        :length => { :is => 2 }

  validates :password,  :presence => {:on => :create},
                        :confirmation => true

  validates :password_confirmation, :presence => true

  def get_privileges
    privileges = Array.new

    self.roles.each do |r|
     r.privileges.each do |p|
       privileges << p unless privileges.include?(p)
     end
    end

    privileges
  end

  def get_apps
    apps = Array.new

    self.get_privileges.each do |p|
      p.apps.each do |a|
        apps << a unless apps.include?(a)
      end
    end

    apps
  end

end