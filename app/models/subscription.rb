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

  validates :tenant,         :presence => {:on => :create}
  validates :plan,           :presence => {:on => :create}
  validates :user,           :presence => {:on => :create}
  validates :price,          :presence => {:on => :create}
  validates :payment_period, :numericality => { :greater_than => 0 }

  scope :commercial,                where("subscriptions.price > 0")
  scope :free,                      where("subscriptions.price = 0")
  scope :with_recurring_profile,    where("paypal_recurring_payment_profile_token IS NOT NULL")
  scope :without_recurring_profile, where("paypal_recurring_payment_profile_token IS NULL")
  scope :notifier,                  commercial.joins(:user, :plan, :tenant).where("tenants.passive_at IS NULL ") \
                                    .select("tenants.id as tenant_id, users.email, users.name as user_name, users.locale, subscriptions.price, subscriptions.next_payment_date, plans.name as plan_name")

  def self.find_trials_without_recurring_profile(next_payment_date = 10.days.from_now)
    notifier.without_recurring_profile.where("next_payment_date > ? AND next_payment_date < ?", next_payment_date.beginning_of_day, next_payment_date.end_of_day)
  end

  # Find due trials to cancel account
  def self.find_finished_trials
    notifier.without_recurring_profile.where("next_payment_date < ?", 1.days.ago.end_of_day)
  end

  def self.find_payment_failures(next_payment_date = 10.days.ago)
    notifier.with_recurring_profile.where("next_payment_date < ?", next_payment_date.end_of_day)
  end
end
