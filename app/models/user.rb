class User < TenantScopedModel
  devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :name,      :presence => true

  validates :locale,    :presence => true,
                        :inclusion => { :in => %w(en tr ru)},
                        :length => { :is => 2 }

  def privileges
    privileges = Array.new

    self.roles.each do |r|
     r.privileges.each do |p|
       privileges << p unless privileges.include?(p)
     end
    end

    privileges
  end

  def apps
    apps = Array.new

    self.privileges.each do |p|
      p.apps.each do |a|
        apps << a unless apps.include?(a)
      end
    end

    apps
  end

end