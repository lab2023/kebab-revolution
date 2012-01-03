# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Tenants Controller
class TenantsController < ApplicationController
  skip_before_filter  :authenticate,  only: [:create, :valid_host, :bootstrap]
  skip_before_filter  :tenant,        only: [:create, :valid_host]
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
    @tenant = Tenant.new(params[:tenant])
    if @tenant.save
      render json: @@response, status: :created
    else
      @@response[:success] = false
      @tenant.errors.each { |a, m| add_error a, m}
      render json: @@response, status: :unprocessable_entity
    end
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
end
