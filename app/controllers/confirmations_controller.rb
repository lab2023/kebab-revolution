class ConfirmationsController < Devise::ConfirmationsController
  include Devise::Controllers::InternalHelpers

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if successfully_sent?(resource)
      render json: @@response
    else
      render json: {success: false}
    end

  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      #sign_in(resource_name, resource)
      render json: @@response
    else
      render json: {success: false}, :status => :unprocessable_entity
    end
  end
end
