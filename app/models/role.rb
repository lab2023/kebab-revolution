# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Role Model
class Role < TenantScopedModel
  has_and_belongs_to_many :users
  has_and_belongs_to_many :privileges
  validates   :name, :presence => true
end