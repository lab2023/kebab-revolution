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

  validates   :tenant,            :presence => {:on => :create}
  validates   :plan,              :presence => {:on => :create}
  validates   :user,              :presence => {:on => :create}
  validates   :price,             :presence => {:on => :create}
  validates   :payment_period,    :numericality => { :greater_than => 0 }
end
