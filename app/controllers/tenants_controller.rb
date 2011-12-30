class TenantsController < ApplicationController
  skip_before_filter :authenticate, only: [:bootstrap]

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
end
