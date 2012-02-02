# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Subscription Model
class Subscription < ActiveRecord::Base
  has_many :payments
  belongs_to :tenant
  belongs_to :plan
  belongs_to :user

  validates :tenant, :presence => {:on => :create}
  validates :plan, :presence => {:on => :create}
  validates :user, :presence => {:on => :create}
  validates :price, :presence => {:on => :create}
  validates :user_limit, :presence => {:on => :create}, :numericality => {:greater_than => 0, :only_integer => true}
  validates :payment_period, :numericality => {:greater_than => 0}

  scope :commercial, where("subscriptions.price > 0")
  scope :free, where("subscriptions.price = 0")
  scope :with_recurring_profile, where("paypal_payment_token IS NOT NULL")
  scope :without_recurring_profile, where("paypal_payment_token IS NULL")
  scope :notifier, commercial.joins(:user, :plan, :tenant).where("tenants.passive_at IS NULL ") \
                                    .select("tenants.id as tenant_id, users.email, users.name as user_name, users.locale, subscriptions.price, subscriptions.next_payment_date, plans.name as plan_name")

  # Find trials subscription without recurring profile
  #
  # next_payment_date Date
  #
  # Return Collection
  def self.find_trials_without_recurring_profile(next_payment_date = 10.days.from_now)
    notifier.without_recurring_profile.where("next_payment_date > ? AND next_payment_date < ?", next_payment_date.beginning_of_day, next_payment_date.end_of_day)
  end

  # Find due trials to cancel account
  def self.find_finished_trials
    notifier.without_recurring_profile.where("next_payment_date < ?", 1.days.ago.end_of_day)
  end

  # Find payment Failures
  #
  # next_payment_date Date
  #
  # Return Collection
  def self.find_payment_failures(next_payment_date = 10.days.ago)
    notifier.with_recurring_profile.where("next_payment_date < ?", next_payment_date.end_of_day)
  end

  # Change plan type
  #
  # new_plan_id Integer
  # old_plan_id Integer
  #
  # Return false or String
  def self.change_plan_type new_plan_id, old_plan_id
    # KBBTODO refactor this code use switch
    change_plan_type = false
    if old_plan_id == 1 and new_plan_id > 1
      change_plan_type = 'free_to_commercial'
    elsif old_plan_id > 1 and new_plan_id == 1
      change_plan_type = 'commercial_to_free'
    elsif old_plan_id > 1 and new_plan_id > 1 and old_plan_id > new_plan_id
      change_plan_type = 'downgrade'
    elsif old_plan_id > 1 and new_plan_id > 1 and old_plan_id < new_plan_id
      change_plan_type = 'upgrade'
    end
  end

  # Commercial to free
  #
  # We assume that first plan is free plan. We cancel the paypal recurring payment profile if there is a token at
  # subscription table then update subscription table.
  #
  # Return boolean
  def self.commercial_to_free
    @tenant = Tenant.current
    @subscription = Subscription.find_by_tenant_id(@tenant.id)
    @free_plan = Plan.first

    unless @tenant.subscription.paypal_payment_token.nil?
      ppr = PayPal::Recurring.new(:profile_id => @tenant.subscription.paypal_payment_token)
      ppr.cancel
    end

    @subscription.plan_id = @free_plan.id
    @subscription.price = @free_plan.price
    @subscription.user_limit = @free_plan.user_limit
    @subscription.paypal_token = nil
    @subscription.paypal_customer_token = nil
    @subscription.paypal_payment_token = nil
    @subscription.next_payment_date = nil

    return @subscription.save ? true : false
  end

  # Free to Commercial
  #
  # new_plan_id Integer
  #
  # Return boolean
  def self.free_to_commercial new_plan_id
    @tenant = Tenant.current
    @subscription = Subscription.find_by_tenant_id(@tenant.id)
    @commercial_plan = Plan.find(new_plan_id)

    @subscription.plan = @commercial_plan
    @subscription.price = @commercial_plan.price
    @subscription.user_limit = @commercial_plan.user_limit
    @subscription.next_payment_date = Time.zone.now

    return @subscription.save ? true : false
  end

  # Downgrade
  #
  # new_plan_id Integer
  #
  # Return boolean
  def self.downgrade new_plan_id
    @tenant = Tenant.current
    @subscription = Subscription.find_by_tenant_id(@tenant.id)
    @new_plan = Plan.find(new_plan_id)

    unless @tenant.subscription.paypal_payment_token.nil?
      ppr = PayPal::Recurring.new({
                                      :amount => @new_plan.price,
                                      :currency => "USD",
                                      :profile_id => @subscription.paypal_payment_token,
                                      :description => "#{@new_plan.name}" + " - Monthly Subscription",
                                  })

      response = ppr.update_recurring_profile
    end

    @subscription.plan_id = @new_plan.id
    @subscription.price = @new_plan.price
    @subscription.user_limit = @new_plan.user_limit

    return @subscription.save ? true : false
  end

  # Upgrade
  #
  # new_plan_id Integer
  #
  # Return boolean
  def self.upgrade new_plan_id
    @tenant = Tenant.current
    @subscription = Subscription.find_by_tenant_id(@tenant.id)
    @new_plan = Plan.find(new_plan_id)

    unless @tenant.subscription.paypal_payment_token.nil?
      ppr = PayPal::Recurring.new(:profile_id => @tenant.subscription.paypal_payment_token)
      ppr.cancel
    end

    @subscription.plan_id = @new_plan.id
    @subscription.price = @new_plan.price
    @subscription.user_limit = @new_plan.user_limit
    @subscription.payment_period = 1
    @subscription.paypal_token = nil
    @subscription.paypal_customer_token = nil
    @subscription.paypal_payment_token = nil

    return @subscription.save ? true : @subscription.errors
  end
end