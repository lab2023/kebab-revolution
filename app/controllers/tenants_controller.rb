# Kebab 2.0
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenants Controller
class TenantsController < ApplicationController
  skip_before_filter  :tenant,        only: [:create, :valid_subdomain]
  skip_before_filter  :authorize,     only: [:create, :valid_subdomain]
  skip_before_filter  :authenticate

  # POST/tenants
  def create

    Tenant.transaction do

      @plan = Plan.find(params[:plan_id])

      @tenant           = Tenant.new
      @tenant.subdomain = "#{params[:tenant_subdomain]}".downcase
      @tenant.name      = params[:tenant_name].strip

      if @tenant.save

        @user           = User.new
        @user.name      = params[:user_name].strip
        @user.email     = params[:user_email].strip
        @user.password  = params[:user_password].strip
        @user.locale    = 'en'
        @user.time_zone = 'UTC'
        @user.tenant    = @tenant

        admin = Role.create(name: 'Admin', tenant: @tenant)
        admin.privileges << Privilege.all
        admin.save

        @user.roles << admin

        if @user.save

          # KBBTODO Refactor this ugly code
          @subscription                   = Subscription.new
          @subscription.user              = @user
          @subscription.tenant            = @tenant
          @subscription.plan              = @plan
          @subscription.price             = @plan.price
          @subscription.user_limit        = @plan.user_limit
          @subscription.payment_period    = 1
          @subscription.next_payment_date = Time.zone.now + 1.months

          if @subscription.save
            # KBBTODO #75 use delay job for sending mail in future
            TenantMailer.create_tenant(@user, @tenant, params[:user_password]).deliver
            status = :created
            @response[:tenant_host] = "http://" + @tenant.subdomain.to_s + '.' + Kebab.application_url.to_s
          else
            @tenant.delete
            @user.delete
            @subscription.valid?
            status = :unprocessable_entity
          end

        else
          @tenant.delete
          @user.delete
          status = :unprocessable_entity
        end
      else
        status = :unprocessable_entity
      end
    end

    if !@tenant.nil? && @tenant.invalid?
      add_error 'tenant_subdomain', @tenant.errors[:subdomain] unless @tenant.errors[:subdomain].blank?
    end

    if !@user.nil? && @user.invalid?
      add_error 'user_name', @user.errors[:name] unless @user.errors[:name].blank?
      add_error 'user_email', @user.errors[:email] unless @user.errors[:email].blank?
      add_error 'user_password', @user.errors[:password] unless @user.errors[:password].blank?
    end

    render json: @response, status: status
  end

  # GET/tenant/1
  def show
    @response[:data]         = Hash.new
    @response[:data][:next]  = @current_tenant.subscription
    @response[:data][:older] = @current_tenant.subscription.payments

    render json: @response
  end

  # DELETE/tenants/:id
  # KBBTODO move all delete code to tenants#delete private method
  def destroy
    if is_owner session[:user_id]
      if @current_tenant.subscription.paypal_payment_token
        ppr = PayPal::Recurring.new(:profile_id => @current_tenant.subscription.paypal_payment_token)
        ppr.cancel
      end
      @current_tenant.active = false
      @current_tenant.save
      logout
      render json: @response
    else
      add_notice 'ERR', 'only owner can delete the account'
      render json: {success: false}
    end
  end

  # GET/tenants/valid_subdomain?subdomain=subdomain
  def valid_subdomain
    subdomain_tenant = Tenant.new
    subdomain_tenant.subdomain = params[:subdomain]
    subdomain_tenant.valid?

    if subdomain_tenant.errors[:subdomain].blank?
      render json: @response
    else
      render json: {success: false}
    end
  end
end