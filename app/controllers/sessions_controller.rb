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
    user = @current_tenant.users.find_by_email(params[:email])
    unless login user, params[:password]
      @response[:success] = false
    end

    render json: @response
  end

  # DELETE/sessions
  def destroy
    logout
    render json: @response
  end
end
