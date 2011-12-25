class PasswordsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if successfully_sent?(resource)
      render json: @@response, status: :found
    else
      add_error 'email', 'email not founded'
      render json: @@response, status: :bad_request
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      sign_in(resource_name, resource)
      render json: @@response
    else
      render json: {success: false}, status: 400
    end
  end

end