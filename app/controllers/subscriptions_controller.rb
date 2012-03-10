# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT
#
# Subscriptions Controller
class SubscriptionsController < ApplicationController
  skip_before_filter :authorize, :only => [:limits]

  # GET/subscriptions/next_subscription
  def next_subscription
    subscription = @current_tenant.subscription
    response = {success: true}
    response[:user_limit] = "#{@current_tenant.users.enable.count}" + " / " + "#{@current_tenant.subscription.user_limit}"
    response[:machine_limit] = "#{@current_tenant.machines.active.count}" + " / " + "#{@current_tenant.subscription.machine_limit}"
    response[:tanker_limit] = "#{@current_tenant.tankers.enable.count}" + " / " + "#{@current_tenant.subscription.tanker_limit}"
    response[:plan_id] = subscription.plan.id
    response[:plan_name] = subscription.plan.name
    response[:created_at] = subscription.created_at
    response[:price] = subscription.price
    response[:next_payment_date] = subscription.next_payment_date
    response[:payment_period] = subscription.payment_period
    response[:paypal_active] = subscription.paypal_payment_token ? true : false
    render json: response
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
                                    :amount       => @plan.price,
                                    :currency     => "USD",
                                    :bg_color     => "EFC687",
                                    :brand_name   => "Kebab Project",
                                    :logo         => "http://www.kebab-project.com/assets/images/logo.jpg"
                                })
    response = ppr.checkout
    if response.valid?
      @response[:checkout_url] = response.checkout_url
      render json: @response
    else
      render json: {success: false}
    end
  end

  # GET/subscriptions/paypal_recurring_payment_success
  def paypal_recurring_payment_success

    @subscription = @current_tenant.subscription
    ppr = PayPal::Recurring.new({
                                    :amount => "#{@subscription.price}",
                                    :currency => "USD",
                                    :description => "#{@subscription.plan.name}" + " - Monthly Subscription",
                                    :frequency => 1,
                                    :token => params[:token], #profile token
                                    :period => :monthly,
                                    :payer_id => params[:PayerID], #payer token
                                    :start_at => @subscription.next_payment_date,
                                    :failed => 10,  # KBBTODO #107 add to config file
                                    :outstanding => :next_billing
                                })

    response = ppr.create_recurring_profile
    if response.profile_id.to_s =~ /^I-/
      @subscription.payment_period = 1
      @subscription.paypal_token = params[:token]
      @subscription.paypal_customer_token = params[:PayerID]
      @subscription.paypal_payment_token = response.profile_id
      @subscription.save
      render json: @response
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
    @response['current_plan'] = @current_tenant.subscription.plan.id
    @response['data'] = Plan.order('price')
    render json: @response
  end

  # PUT/subscriptions
  def update
    @subscription = @current_tenant.subscription
    @response['change_plan_type'] = Subscription.change_plan_type @subscription.plan.id, params[:new_plan_id].to_i

    case @response['change_plan_type']
      when 'free_to_commercial'
        @response[:success] = Subscription.free_to_commercial @subscription, params[:new_plan_id].to_i
      when 'commercial_to_free'
        return render json: @response unless check_limits params[:new_plan_id].to_i
        @response[:success] = Subscription.commercial_to_free @subscription
      when 'downgrade'
        return render json: @response unless check_limits params[:new_plan_id].to_i
        @response[:errors] = Subscription.downgrade @subscription, params[:new_plan_id].to_i
      when 'upgrade'
        @response[:success] = Subscription.upgrade @subscription, params[:new_plan_id].to_i
      else
        @response[:success] = false
    end

    render json: @response
  end

  # Limits
  #
  # Return json
  def limits
    @response[:data] = {
        user: {total:  @current_tenant.users.enable.count, limit: @current_tenant.subscription.user_limit},
        machine: {total:  @current_tenant.machines.active.count, limit: @current_tenant.subscription.machine_limit},
        tanker: {total:  @current_tenant.tankers.enable.count, limit: @current_tenant.subscription.tanker_limit}
    }
    render json: @response
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
      @response[:success] = false
      add_notice('error', I18n.t('notice.subscriptions.too_many_active_user_for_downgrade_plan'))
      retVal = false
    end

    unless reach_plan_machine_limit? new_plan_id
      @response[:success] = false
      add_notice('info', I18n.t('notice.subscriptions.too_many_active_machine_for_downgrade_plan'))
      retVal = false
    end

    unless reach_plan_tanker_limit? new_plan_id
      @response[:success] = false
      add_notice('error', I18n.t('notice.subscriptions.too_many_active_tanker_for_downgrade_plan'))
      retVal = false
    end

    retVal
  end
end