# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Subscription Plan Model
class Plan < ActiveRecord::Base
  has_many :subscriptions

  scope :commercial, where("price > 0")
  scope :free,       where("price = 0")

  validates :name,        :presence => true
  validates :price,       :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :user_limit,  :presence => true, :numericality => {:greater_than => 0, :only_integer => true}
  validates :recommended, :inclusion => { :in => [true, false] }
end
