# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# User Model
class User < TenantScopedModel
  has_secure_password
  has_and_belongs_to_many :roles
  has_one                 :subscription

  # Email regex standard
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email,     :presence => {:on => :create}, :uniqueness => true, :format => {:with => EMAIL_REGEX}
  validates :name,      :presence => true
  validates :time_zone, :presence => true
  validates :locale,    :presence => true, :inclusion => {:in => %w(en tr ru)}, :length => {:is => 2}  # KBBTODO move all supported language one place
  validates :password,  :presence => {:on => :create}, :confirmation => true
  validates :password_confirmation, :presence => {:on => :create}

  scope :active,  where("users.passive_at IS NULL")
  scope :passive, where("users.passive_at IS NOT NULL")

  # Pubic: Return users privileges hash
  # KBBTODO refactor methods in loop
  def get_privileges
    privileges = Array.new

    self.roles.each do |r|
     r.privileges.each do |p|
       privileges << p unless privileges.include?(p)
     end
    end

    privileges
  end

  # Public: Return users apps hash
  # KBBTODO refactor methods in loop
  def get_applications
    applications = Array.new

    self.get_privileges.each do |p|
      p.applications.each do |a|
        applications << a unless applications.include?(a)
      end
    end

    applications
  end

  # Public: Return users resources hash
  # KBBTODO refactor methods in loop
  def get_resources
    resources = Array.new

    self.get_privileges.each do |p|
      p.resources.each do |a|
        resources << a unless resources.include?(a)
      end
    end

    resources
  end


end