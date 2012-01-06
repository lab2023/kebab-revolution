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
      user[:applications] = User.find(session[:user_id]).get_applications
      user[:privileges]   = User.find(session[:user_id]).get_privileges
      @@response['user']  = user
    end
    render json: @@response
  end

  # POST/tenants
  # KBBTODO move all delete code to tenants#delete private method
  def create

    Tenant.transaction do

      @plan = Plan.find(params[:plan][:id])
      @tenant = Tenant.new(params[:tenant])

      if @tenant.save

        Tenant.current = @tenant
        Time.zone = params[:user][:time_zone]
        I18n.locale = params[:user][:locale]

        @user   = User.new(params[:user])
        admin = Role.create(name: 'Admin')
        admin.privileges << Privilege.all
        admin.save
        @user.tenant = @tenant
        @user.roles << admin
        @user.save


        if @user.save

          # KBBTODO Refactor this ugly code
          @subscription = Subscription.new
          @subscription.user    = @user
          @subscription.tenant  = @tenant
          @subscription.plan    = @plan
          @subscription.price   = @plan.price
          @subscription.payment_period = 0
          @subscription.next_payment_date = Time.zone.now + 1.months

          if @subscription.save
            # KBBTODO use delay job for sending mail in future
            TenantMailer.create_tenant(@user, @tenant, @subscription).deliver
            login @user, params[:user][:password]
            status = :created
          else
            @tenant.delete
            @user.delete
            @subscription.valid?
            @subscription.errors.each { |a, m| add_error a, m}
            status = :unprocessable_entity
          end

        else
          @tenant.delete
          @user.delete
          @user.errors.each { |a, m| add_error a, m}
          status = :unprocessable_entity
        end
      else
        @tenant.errors.each { |a, m| add_error a, m}
        status = :unprocessable_entity
      end
    end
    render json: @@response, status: status
  end

  # GET/tenants/valid_host?host=host_name
  # KBBTODO set invalid tenant from one place
  def valid_host
    if Tenant.find_by_host(params[:host]) != nil \
       || %w(www help support api apps status blog lab2023 static).include?(params[:host].split('.').first) \
       || params[:host].split('.').count != 3
      render json: {success: false}
    else
      render json: @@response
    end
  end
end
