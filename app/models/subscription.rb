# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Subscription Model
class Subscription < ActiveRecord::Base
  has_many   :payments
  belongs_to :tenant
  belongs_to :plan
  belongs_to :user

  validates  :tenant, :presence => true
  validates  :plan,   :presence => true
  validates  :user,   :presence => true
end
