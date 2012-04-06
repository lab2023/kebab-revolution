# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# User Model
class User < ActiveRecord::Base
  has_secure_password
  belongs_to :tenant
  has_and_belongs_to_many :roles
  has_one                 :subscription
  has_many                :privileges, through: :roles, uniq: true
  has_many                :resources, through: :privileges, uniq: true
  has_many                :applications, through: :privileges, uniq: true

  validates :tenant, :presence => true
  # Email regex standard
  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  validates :email,     :presence => {:on => :create}, :uniqueness => true, :format => {:with => EMAIL_REGEX}
  validates :name,      :presence => true
  validates :time_zone, :presence => true
  validates :locale,    :presence => true, :inclusion => {:in => %w(en tr ru)}, :length => {:is => 2}  # KBBTODO move all supported language one place
  validates :password,  :presence => {:on => :create}

  scope :enable,  where("users.disabled = 0")
  scope :disable, where("users.disabled = 1")
end