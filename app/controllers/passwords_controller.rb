class PasswordsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    new_password = rand(10000000000000).floor.to_s(36)
    user.password = new_password
    user.password_confirmation = new_password
    user.save

    render json: new_password
  end

end
