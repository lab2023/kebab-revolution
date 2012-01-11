# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Privilege Model
class Privilege < ActiveRecord::Base
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :applications
  has_and_belongs_to_many :resources

  translates  :name, :info, :fallbacks_for_empty_translations => true

  validates   :sys_name,  :presence => true, :uniqueness => true
  validates   :name,      :presence => true

end
