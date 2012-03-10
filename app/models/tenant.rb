# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenant Model
class Tenant < ActiveRecord::Base
  has_one   :subscription
  has_many  :users
  has_many  :roles
  has_many  :companies
  has_many  :personnel
  has_many  :projects
  has_many  :worksites
  has_many  :machines
  has_many  :engine_times
  has_many  :kilometers
  has_many  :machine_activities
  has_many  :tankers
  has_many  :tanker_sensors
  has_many  :cameras


  # Tenant regex standard
  SUBDOMAIN =/\A[a-zA-Z0-9]+\z/i
  validates :name,      :presence => {:on => :create}, :uniqueness => true, :length => {:in => 4..255}
  validates :subdomain, :presence => {:on => :create}, :uniqueness => true, :exclusion => {:in => Kebab.invalid_tenant_names }, :length => {:in => 4..61},:format => {:with => SUBDOMAIN}

  scope :active,  where("tenants.passive_at IS NULL")
  scope :passive, where("tenants.passive_at IS NOT NULL")
end
