# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Pages Controller
class PagesController < ApplicationController
  skip_around_filter :tenant,       only: [:index, :register, :plans]
  skip_before_filter :authenticate, only: [:index, :register, :plans, :login]
  skip_before_filter :authorize

  # GET/pages/index
  def index
  end

  # GET/pages/desktop
  def desktop
    @bootstrap = bootstrap
  end

  # GET/pages/login
  def login
    @bootstrap = bootstrap
  end

  # GET/pages/plans
  def plans
    @plans = Plan.order("price")
  end

  # GET/pages/register
  def register
    @bootstrap = bootstrap false
  end

  # GET/pages/paypal_credential
  def paypal_credential
    @plan = @current_tenant.subscription.plan
    ppr = PayPal::Recurring.new({
                                    :return_url   => "http://#{request.host}/pages/paypal_recurring_payment_success",
                                    :cancel_url   => "http://#{request.host}/pages/paypal_recurring_payment_failed",
                                    :description  => "#{@plan.name}" + " - Monthly Subscription",
                                    :amount       => "#{@plan.price}" + ".00",
                                    :currency     => "USD"
                                })
    response = ppr.checkout
    if response.valid?
      render json: response.checkout_url
    else
      render json: {success: false}
    end
  end

  # GET/pages/paypal_recurring_payment_success
  def paypal_recurring_payment_success

    @subscription = @current_tenant.subscription
    ppr = PayPal::Recurring.new({
                                    :amount      => "#{@subscription.price}",
                                    :currency    => "USD",
                                    :description => "#{@subscription.plan.name}" + " - Monthly Subscription",
                                    :frequency   => 1,
                                    :token       => params[:token],                                                         #profile token
                                    :period      => :monthly,
                                    :payer_id    => params[:PayerID],                                                      #payer token
                                    :start_at    => @subscription.next_payment_date,
                                    :failed      => 10,
                                    :outstanding => :next_billing
                                })

    response = ppr.create_recurring_profile
    if response.profile_id.to_s =~ /^I-/
      @subscription.paypal_token                           = params[:token]
      @subscription.paypal_customer_token                  = params[:PayerID]
      @subscription.paypal_recurring_payment_profile_token = response.profile_id
      @subscription.save
      render json: @@response
    else
      render json: {success: false}
    end
  end

  # GET/pages/paypal_recurring_payment_failed
  def paypal_recurring_payment_failed
    render text: 'Paypal payment failed'
  end

end
