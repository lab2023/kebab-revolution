class PasswordsController < ApplicationController
  skip_before_filter :authenticate, only: [:create]

  def create
    @user = User.find_by_email(params[:email])
    new_password = rand(10000000000000).floor.to_s(36)
    @user.password = new_password
    @user.password_confirmation = new_password
    if @user.save
      UserMailer.forget_password(@user).deliver
      status = :ok
    else
      @@response[:success] = false
      status = :unprocessable_entity
    end

    render json: @user, status: status
  end

end
