class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => :create
  include Devise::Controllers::InternalHelpers

  def create
    resource = warden.authenticate!(scope: resource_name)

    user = User.select('id, email, name, locale').find(resource.id)
    user[:privileges] = user.privileges
    user[:apps] = user.apps

    @@response[:user] = [user]

    render json: @@response
  end

  def destroy
    signed_in = signed_in?(resource_name)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render json: @@response
  end
end
