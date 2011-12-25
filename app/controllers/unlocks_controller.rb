class UnlocksController < Devise::UnlocksController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  # POST /resource/unlock
  def create
    self.resource = resource_class.send_unlock_instructions(params[resource_name])

    if successfully_sent?(resource)
      render json: @@response, status: :found
    else
      add_error 'email', 'email not founded'
      render json: @@response, status: :bad_request
    end
  end

  # GET /resource/unlock?unlock_token=abcdef
  def show
    self.resource = resource_class.unlock_access_by_token(params[:unlock_token])

    if resource.errors.empty?
      sign_in(resource_name, resource)
      render json: @@response
    else
      render json: {success: false}, status: 400
    end
  end
end
