# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Resource Model
class Resource < ActiveRecord::Base
  has_and_belongs_to_many :privileges

  validates   :sys_name,  :presence => true, :uniqueness => true
end
