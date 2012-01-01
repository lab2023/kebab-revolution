# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Sessions Controller
class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:create]
  skip_before_filter :authorize

  # POST/sessions
  def create
    # KBBTODO status code
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      session[:acl] = acl
    else
      @@response[:success] = false
    end

    render json: @@response
  end

  # DELETE/sessions
  def destroy
    session[:user_id] = nil
    session[:acl] = nil
    render json: @@response
  end
end
