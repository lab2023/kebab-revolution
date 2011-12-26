class TenantsController < ApplicationController

  def register
    @@response[request_forgery_protection_token] = form_authenticity_token
    @@response['tenant'] = Tenant.select('id, host, name').find_by_host!(request.host)
    render json: @@response, callback: params[:callback]
  end
end
