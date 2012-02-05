# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Application Controller
class ApplicationController < ActionController::Base
  # KBBTODO #92 solve protect_from_forget problem
  #protect_from_forgery

  around_filter :tenant
  before_filter :authenticate
  before_filter :authorize
  before_filter :i18n_locale

  # Public: Response hash for all xhr request
  @@response = {:success => true}

  # Public: Response status code for all xhr request
  @@status   = 200

  protected

  attr_reader :current_tenant

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
    if Tenant.active.find_by_host(request.host) != nil
      @current_tenant = Tenant.active.find_by_host!(request.host)
      @current_tenant.with { yield }
    else
      @@response = {:success => false}
      add_notice 'ERR', I18n.t('notice.invalid_tenant')
      logger.warn "404 Tenant filter" + log_client_info
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
    unless session[:user_id]
      logger.warn "403 Authenticate" + log_client_info
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
  # Returns void, Json
  def authorize
    unless session[:acl].include?(params[:controller].to_s + '.' + params[:action].to_s)
      logger.warn "401 Authorize" + log_client_info
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

  # Protected: Return users acl array
  #
  # Examples
  #
  #   acl
  #   #=> {
  #   #=>  'sessions/create',
  #   #=>  'sessions/destroy'
  #   #=> }
  #
  # Returns Acl hash
  def acl
    acl_array = Array.new

    user_resources_raw = session[:user_id].nil? ? Array.new : User.find(session[:user_id]).get_resources
    user_resources_raw.each do |resource|
      acl_array << resource.sys_name
    end

    acl_array
  end

  # Protected: login
  #
  # user      UserModel
  # password  String
  #
  # Return boolean
  def login user, password
    if user && user.passive_at == nil && user.authenticate(password)
      session[:user_id] = user.id
      session[:locale] = user.locale
      session[:acl] = acl

      I18n.locale = user.locale
      Time.zone   = user.time_zone

      true
    else
      logger.warn "Can not login" + log_client_info
      false
    end
  end

  # Protected: logout
  def logout
    session[:user_id] = nil
    session[:locale] = nil
    session[:acl] = nil
  end

  # Protected: bootstrap
  #
  # tenant  boolean
  #
  # Return hash
  def bootstrap tenant = true
    bootstrap_hash = Hash.new
    bootstrap_hash['root'] = "static"
    bootstrap_hash[request_forgery_protection_token] = form_authenticity_token
    bootstrap_hash['tenant'] = Tenant.select('id, host, name').find_by_host!(request.host) if tenant
    bootstrap_hash['locale'] = {default_locale: I18n.locale, available_locales: I18n.available_locales}
    unless session[:user_id].nil?
      user = User.select("name, email").find(session[:user_id])
      user[:applications] = User.find(session[:user_id]).get_applications
      user[:privileges]   = User.find(session[:user_id]).get_privileges
      bootstrap_hash['user']  = user
    end
    bootstrap_hash
  end

  # Protected: is_owner
  #
  # id    Integer
  #
  # Return boolean
  def is_owner id
    return id == @current_tenant.subscription.user_id
  end

  # Protected reach_user_limit?
  #
  # Return boolean
  def reach_user_limit?
    @current_tenant.subscription.user_limit < User.active.all.count
  end

  # Protected reach_user_limit?
  #
  # Return boolean
  def reach_plan_user_limit? plan_id
    Plan.find(plan_id).user_limit >= User.active.all.count
  end

  # Request info for logger
  #
  # Return string
  def log_client_info
   return "\n IP\t#{request.remote_ip} \n METHOD\t#{request.method} \n URL\t#{request.url} \n PARAMS\t#{request.params.as_json} \n AJAX\t#{request.xhr? ? 'TRUE' : 'FALSE'}"
  end
end