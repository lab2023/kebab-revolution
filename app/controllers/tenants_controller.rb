# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenants Controller
class TenantsController < ApplicationController
  skip_before_filter  :tenant,        only: [:create, :valid_host, :paypal_credentials]
  skip_before_filter  :authenticate
  skip_before_filter  :authorize

  # GET/tenants/bootstrap
  def bootstrap
    @@response[request_forgery_protection_token] = form_authenticity_token
    @@response['tenant'] = Tenant.select('id, host, name').find_by_host!(request.host)
    @@response['locale'] = {default_locale: I18n.locale, available_locales: I18n.available_locales}
    unless session[:user_id].nil?
      user = User.select("name, email").find(session[:user_id])
      user[:apps] = User.find(session[:user_id]).get_apps
      user[:privileges] = User.find(session[:user_id]).get_privileges
      @@response['user'] = user
    end
    render json: @@response
  end

  # POST/tenants
  def create

    Tenant.transaction do

      @plan = Plan.find(params[:plan][:id])
      @tenant = Tenant.new(params[:tenant])

      if @tenant.save
        Tenant.current = @tenant

        @user   = User.new(params[:user])
        @user.tenant = @tenant
        @user.roles << tenant_initial_data(params[:user][:locale])

        if @user.save
          @subscription = Subscription.new
          @subscription.user = @user
          @subscription.tenant = @tenant
          @subscription.plan = @plan
          @subscription.price = @plan.price
          @subscription.payment_period = 0
          @subscription.next_payment_date = Time.zone.now + 1.months

          if @subscription.save
            login @user, params[:user][:password]
            status = :created
          else
            @tenant.delete
            @user.delete
            @subscription.valid?
            @@response[:sub_errors] = @subscription.errors
            status = :unprocessable_entity
          end

        else
          @tenant.delete
          @user.delete
          @@response[:user_error] = @user.errors
          status = :unprocessable_entity
        end
      else
        @@response[:success] = false
        status = :unprocessable_entity
      end
    end
    render json: @@response, status: status
  end

  # GET/tenants/valid_host?host=host_name
  def valid_host
    # KBBTODO set invalid tenant from one place
    if Tenant.find_by_host(:params[:host]) != nil || %w(www help support api apps status blog lab2023 static).include?(params[:host])
      render json: {success: false}
    else
      render json: @@response
    end
  end

  # GET/tenants/paypal_credentials
  def paypal_credentials
    if Plan.find(params[:plan][:id]) != nil && (1 < params[:plan][:id].to_i)
      checkout_url = paypal_credential Plan.find(params[:plan][:id])
      if checkout_url != false
        @@response[:url] = checkout_url
      else
        @@response[:success] = false
      end
    else
      @@response[:success] = false
    end
    render json: @@response
  end

end
