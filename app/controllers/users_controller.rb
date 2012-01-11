# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Users Controller
class UsersController < ApplicationController
  skip_before_filter :authorize

  # POST/users/update_profile
  def update_profile
    @user = User.find(session[:user_id])
    if @user.update_attributes({email: params[:email], name: params[:name], locale: params[:locale], time_zone: params[:time_zone]})
      render json: @@response
    else
      @@response[:error] = @user.errors.each { |a, m| add_error a, m}
      render json: @@response
    end
  end

  # GET/users/get_profile
  def get_profile
    @@response[:data] = User.select("email, name, locale, time_zone").find(session[:user_id])
    render json: @@response
  end
end
