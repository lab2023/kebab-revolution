# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT
#
# Subscriptions Controller
class SubscriptionsController < ApplicationController

  # GET/subscriptions/next_subscription
  def next_subscription
    subscription =  @current_tenant.subscription
    @@response[:plan_name]          = subscription.plan.name
    @@response[:created_at]         = subscription.created_at
    @@response[:price]              = subscription.price
    @@response[:next_payment_date]  = subscription.next_payment_date
    @@response[:payment_period]     = subscription.payment_period
    @@response[:paypal_active]      = subscription.paypal_recurring_payment_profile_token ? true : false
    render json: @@response
  end

  # GET/subscription/payments
  def payments
    render json: @current_tenant.subscription.payments
  end

  # GET/subscriptions/paypal_credential
  def paypal_credential
    @plan = @current_tenant.subscription.plan
    ppr = PayPal::Recurring.new({
                                    :return_url   => "http://#{request.host}/subscriptions/paypal_recurring_payment_success",
                                    :cancel_url   => "http://#{request.host}/subscriptions/paypal_recurring_payment_failed",
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

  # GET/subscriptions/paypal_recurring_payment_success
  def paypal_recurring_payment_success

    @subscription = @current_tenant.subscription
    ppr = PayPal::Recurring.new({
                                    :amount      => "#{@subscription.price}",
                                    :currency    => "USD",
                                    :description => "#{@subscription.plan.name}" + " - Monthly Subscription",
                                    :frequency   => 1,
                                    :token       => params[:token],                       #profile token
                                    :period      => :monthly,
                                    :payer_id    => params[:PayerID],                     #payer token
                                    :start_at    => @subscription.next_payment_date,
                                    :failed      => 10,
                                    :outstanding => :next_billing
                                })

    response = ppr.create_recurring_profile
    if response.profile_id.to_s =~ /^I-/
      @subscription.payment_period                         = 1
      @subscription.paypal_token                           = params[:token]
      @subscription.paypal_customer_token                  = params[:PayerID]
      @subscription.paypal_recurring_payment_profile_token = response.profile_id
      @subscription.save
      render json: @@response
    else
      render json: {success: false}
    end
  end

  # GET/subscriptions/paypal_recurring_payment_failed
  def paypal_recurring_payment_failed
    render text: 'Paypal payment failed'
  end

  # GET/subscriptions/plans
  def plans
    @@response['current_plan'] = @current_tenant.subscription.plan.id
    @@response['plans'] = Plan.order('price')
    render json: @@response
  end

  # PUT/subscriptions
  def update
    @@response['change_plan_type'] = Subscription.change_plan_type params[:new_plan_id].to_i, @current_tenant.subscription.plan.id
    case @@response['change_plan_type']
      when 'free_to_commercial'
        Subscription.free_to_commercial params[:new_plan_id].to_i
      when 'commercial_to_free'
        return render json: @@response unless check_limits params[:new_plan_id].to_i
        Subscription.commercial_to_free
      when 'downgrade'
        return render json: @@response unless check_limits params[:new_plan_id].to_i
        @@response[:errors] = Subscription.downgrade params[:new_plan_id].to_i unless Subscription.downgrade params[:new_plan_id].to_i
      when 'upgrade'
        Subscription.upgrade params[:new_plan_id].to_i
      else
        @@response[:success] = false
    end

    render json: @@response
  end

  private

  # Check limits
  #
  # new_plan_id Integer
  #
  # Return boolean
  def check_limits new_plan_id
    retVal = true

    #KBBTODO #100
    unless reach_plan_user_limit? new_plan_id
      @@response[:success] = false
      add_notice('ERROR', 'User limit false')
      retVal = false
    end

    retVal
  end
end