# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Subscription Plan Model
class Plan < ActiveRecord::Base
  has_many :subscriptions

  validates :name,        :presence => true
  validates :amount,      :presence => true,
                          :numericality => {:greater_than_or_equal_to => 0}
  validates :user_limit,  :presence => true,
                          :numericality => {:greater_than => 0, :only_integer => true}
  validates :recommended, :inclusion => { :in => [true, false] }
  validate  :only_one_recommended_plan



  def only_one_recommended_plan
    if Plan.where('recommended = true').count() > 0
      errors.add(:recommended, "recommended plan is already choiced")
    end
  end
end
