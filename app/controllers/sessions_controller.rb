class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:create]
  skip_before_filter :authorize

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:acl] = acl
    else
      @@response[:success] = false
    end

    render json: @@response
  end

  def destroy
    session[:user_id] = nil
    session[:acl] = nil
    render json: @@response
  end
end
