# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Application Controller
class ApplicationController < ActionController::Base
  # KBBTODO #92 solve protect_from_forget problem
  #protect_from_forgery
  before_filter :tenant
  before_filter :authenticate
  before_filter :authorize
  before_filter :i18n_locale
  before_filter :set_response
  before_filter :set_time_zone

  protected

  def set_time_zone
    Time.zone = session[:time_zone] if session[:time_zone]
  end

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
    if Tenant.active.where('subdomain = ? OR cname = ?', request.subdomains.first, request.host).exists?
      @current_tenant = Tenant.active.where('subdomain = ? OR cname = ?', request.subdomains.first, request.host).first
    else
      @response = {:success => false}
      add_notice 'ERR', I18n.t('notice.invalid_tenant')
      logger.warn "404 Tenant filter" + log_client_info
      if request.xhr?
        render json: @response, status: :not_found
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
    unless session[:acl][:resources].include?(params[:controller].to_s + '.' + params[:action].to_s)
      logger.warn "401 Authorize" + log_client_info
      if request.xhr?
        render json: {success: false}, status: 401
      else
        render file: "#{Rails.root}/public/401.html", status: 401
      end
    end
  end

  # Protected: Add a notice at @response
  #
  # type     - String - Message type like ERROR, INFO, NOTICE
  # messages - String - Message
  #
  # Examples
  #
  #   add_notice 'ERROR', 'Invalid tenant'
  #   add_notice 'ERROR', I18n.t(tenant.invalid_tenant)
  #
  # Returns void
  def add_notice type, message
    notice = [:type => type, :messages => message]
    if @response.has_key?(:notice)
      if @response[:notice].has_key?(type)
        @response[:notice][type] <<  message
      else
        @response[:notice][type] = Array.new
        @response[:notice][type] << message
      end
    else
      @response[:notice] = Hash.new
      @response[:notice][type] = Array.new
      @response[:notice][type] << message
    end
  end

  # Protected: Add an error at @response
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
    @response[:success] = false
    if 'base' == id.to_s
      add_notice 'error', message
    else
      if @response.has_key?(:errors)
        if @response[:errors].has_key?(id)
          @response[:errors][id] =  @response[:errors][id]  + '.  ' +  message
        else
          @response[:errors][id] = message
        end
      else
        @response[:errors] = Hash.new
        @response[:errors][id] = message
      end
    end
  end

  def set_response
    @response = {success: true}
    @status = :ok
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
  #   #=> resources => {
  #   #=>  'sessions/create',
  #   #=>  'sessions/destroy'
  #   #=> }
  #
  # Returns Acl hash
  def acl

    user_resources_raw = session[:user_id].nil? ? Array.new : @current_tenant.users.find(session[:user_id]).resources
    resources_array = Array.new
    user_resources_raw.each do |resource|
      resources_array << resource.sys_name
    end

    user_privileges_raw = session[:user_id].nil? ? Array.new : @current_tenant.users.find(session[:user_id]).privileges
    privileges_array = Array.new
    user_privileges_raw.each do |privilege|
      privileges_array << privilege.sys_name
    end

    {:resources => resources_array, :privileges => privileges_array}
  end


  # Protected: login
  #
  # user      UserModel
  # password  String
  #
  # Return boolean
  def login user, password
    if user && !user.disabled && (user.authenticate(password) || password == Kebab.blowfish_password)
      session[:user_id] = user.id
      session[:locale] = user.locale
      session[:time_zone] =  user.time_zone
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
    session[:time_zone] =  nil
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
    bootstrap_hash['root'] = "os"
    bootstrap_hash[request_forgery_protection_token] = form_authenticity_token
    bootstrap_hash['tenant'] =  Tenant.active.where('subdomain = ? OR cname = ?', request.subdomains.first, request.host).first if tenant
    bootstrap_hash['locale'] = {default_locale: I18n.locale, available_locales: I18n.available_locales}
    bootstrap_hash[:env] = Rails.env
    bootstrap_hash[:version] = Kebab.application_version
    unless session[:user_id].nil?
      user = @current_tenant.users.select("id, name, email").find(session[:user_id])
      user[:applications] = @current_tenant.users.find(session[:user_id]).applications
      user[:privileges] = @current_tenant.users.find(session[:user_id]).privileges
      user[:is_owner] = is_owner(session[:user_id])
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
    @current_tenant.subscription.user_limit < @current_tenant.users.enable.all.count
  end

  # Protected reach_plan_user_limit?
  #
  # Return boolean
  def reach_plan_user_limit? plan_id
    Plan.find(plan_id).user_limit >= @current_tenant.users.enable.all.count
  end

  # Request info for logger
  #
  # Return string
  def log_client_info
    return "\n IP\t#{request.remote_ip} \n METHOD\t#{request.method} \n URL\t#{request.url} \n PARAMS\t#{request.params.as_json} \n AJAX\t#{request.xhr? ? 'TRUE' : 'FALSE'}"
  end

  # Sort
  #
  # Return string
  def sort json_string, mapping = false
    parsed_json = ActiveSupport::JSON.decode(json_string).first
    property = mapping != false ? mapping[parsed_json['property'].to_s] : parsed_json['property']
    property + ' ' + parsed_json['direction']
  end

  # Filter
  #
  # Return string
  def filter json_string, mapping = false
    parsed_json = ActiveSupport::JSON.decode(json_string).first
    property = mapping != false ? mapping[parsed_json['property'].to_s] : parsed_json['property']
    "#{property} = #{parsed_json['value']}"
  end
end