class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      status = 200
    else
      @@response[:success] = false
      status = 401
    end

    render json: @@response, status: status
  end

  def destroy
    session[:user_id] = nil
    render json: @@response
  end
end
