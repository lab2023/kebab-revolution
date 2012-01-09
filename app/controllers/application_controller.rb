# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Application Controller
class ApplicationController < ActionController::Base
  #protect_from_forgery

  before_filter :tenant
  around_filter :with_tenant
  before_filter :authenticate
  before_filter :authorize
  before_filter :i18n_locale

  # Public: Response hash for all xhr request
  @@response = {:success => true}

  # Public: Response status code for all xhr request
  @@status   = 200

  protected

  attr_reader :current_tenant

  def with_tenant
    @current_tenant = Tenant.find_by_host!(request.host)
    @current_tenant.with { yield }
  end

  # KBBTODO
  # Protected:
  # attr_reader :current_tenant

  # Protected: Check current tenant
  #
  # Examples
  #
  #   tenant
  #   # => {success: false, notice: 'Invalid tenant'} #status 404 if request is xhr
  #   # => render /public/404.html
  #
  # Returns void, Json or render 404 page
  def tenant
    if Tenant.find_by_host(request.host) != nil
      @tenant = Tenant.current = Tenant.find_by_host!(request.host)
    else
      @@response = {:success => false}
      add_notice 'ERR', I18n.t('notice.invalid_tenant')

      if request.xhr?
        render json: @@response, status: :not_found
      else
        render file: "#{Rails.root}/public/404.html", status: 404
      end

    end
  end

  # Protected: Check user authentication
  #
  # Examples
  #
  #   authenticate
  #   # => {success: false} # status 403 unless there is no user_id at session
  #
  # Returns void, Json
  def authenticate
    # KBBTODO add logging
    unless session[:user_id]
      if request.xhr?
        render json: {success: false}, status: 403
      else
        render file: "#{Rails.root}/public/403.html", status: 403
      end
    end
  end

  # Protected: Check user authorize
  #
  # Examples
  #
  #   authorize
  #   # => {success: false} # status 401
  #   # => nil
  #
  # KBBTODO add logging
  # Returns void, Json
  def authorize
    # KBBTODO add logging
    unless session[:acl].include?(request.method.to_s + request.path.to_s)
      if request.xhr?
        render json: {success: false}, status: 401
      else
        render file: "#{Rails.root}/public/401.html", status: 401
      end
    end
  end

  # Protected: Add a notice at @@response
  #
  # type    - String - Message type like ERROR, INFO, NOTICE
  # message - String - Message
  #
  # Examples
  #
  #   add_notice 'ERROR', 'Invalid tenant'
  #   add_notice 'ERROR', I18n.t(tenant.invalid_tenant)
  #
  # Returns void
  def add_notice type, message
    notice = [:type => type, :message => message]
    if @@response.has_key?(:notice)
      @@response[:notice] += notice unless @@response[:notice].include?(notice) || @@response[:notice] == notice
    else
      @@response[:notice] = notice
    end
  end

  # Protected: Add an error at @@response
  #
  # id      - String - Form element id where error is showed
  # message - String - Message
  #
  # Examples
  #
  #   add_error 'email', 'Invalid email format'
  #   add_error 'email', I18n.t(errors.email.invalid_format)
  #
  # Return void
  def add_error id, message
    @@response[:success] = false
    if @@response.has_key?(:error)
      @@response[:error][id] = @@response[:error].has_key?(id) ? ( @@response[:error][id] + '. ' + message ) : message;
    else
      @@response[:error] = Hash.new
      @@response[:error][id] = message
    end
  end

  # Protected: Set locale
  #
  # First check params, then session, then default value at config file.
  #
  # Examples
  #
  #   i18n_locale
  #   # => 'en'
  #
  # Returns i18n.locale with string type
  def i18n_locale
    I18n.locale = i18n_locale_from_param || i18n_locale_from_session || I18n.default_locale
  end

  # Protected: Return locale value from param if exist
  #
  # Returns String
  def i18n_locale_from_param
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        params[:locale]
      end
    end
  end

  # Protected: Return locale value from session if exist
  #
  # Returns String
  def i18n_locale_from_session
    if session[:locale]
      if I18n.available_locales.include?(session[:locale].to_sym)
        session[:locale]
      end
    end
  end

  # Protected: Return users acl hash
  #
  # Examples
  #
  #   acl
  #   #=> {
  #   #=>  'POST/sessions'    => 'sessions/create',
  #   #=>  'DELETE/sessions'  => 'sessions/destroy'
  #   #=> }
  #
  # Returns Acl hash
  def acl
    acl = Hash.new

    user_resources_raw = session[:user_id].nil? ? Hash.new : User.find(session[:user_id]).get_resources
    user_resources_raw.each do |resource|
      acl[resource.sys_path] = resource.sys_name
    end

    acl
  end

  # Protected: Create a credentials
  def paypal_credential plan
    @plan = plan
    ppr = PayPal::Recurring.new({
                                    :return_url   => "http://www.kebab.local/register",
                                    :cancel_url   => "http://www.kebab.local/paypal_cancel",
                                    :description  => "#{@plan.name}" + " - Monthly Subscription",
                                    :amount       => "#{@plan.price}" + ".00",
                                    :currency     => "USD"
                                })
    response = ppr.checkout
    if response.valid?
      response.checkout_url
    else
      false
    end
  end

  # Protected: Create a recurring payment
  #
  # Return Recurring ProfileId
  def paypal_recurring_payment plan, reference, payer_id, token
    @plan = plan
    ppr = PayPal::Recurring.new({
      :amount      => "#{@plan.price}" + ".00",
      :currency    => "USD",
      :description => "#{plan.name}" + " - Monthly Subscription", #plan info
      :frequency   => 1,
      :token       => token,                                      #profile token
      :period      => :monthly,
      :reference   => reference,                                  #Invoice Number
      :payer_id    => payer_id,                                   #payer token
      :start_at    => Time.now,
      :failed      => 15,
      :outstanding => :next_billing
    })

    response = ppr.create_recurring_profile
    response.profile_id
  end

  # Protected: login
  #
  # user      UserModel
  # password  String
  #
  # Return boolean
  def login user, password
    if user && user.authenticate(password)
      session[:user_id] = user.id
      session[:acl] = acl

      I18n.locale = user.locale
      Time.zone   = user.time_zone

      true
    else
      false
    end
  end

  # Protected: logout
  def logout
    session[:user_id] = nil
    session[:acl] = nil
  end
end