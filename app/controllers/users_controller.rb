# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Users Controller
class UsersController < ApplicationController
  skip_before_filter :authorize

  # PUT/users/
  def update
    user = Hash.new
    user[:email]     = params[:email]     if params[:email]
    user[:name]      = params[:name]      if params[:name]
    user[:locale]    = params[:locale]    if params[:locale]
    user[:time_zone] = params[:time_zone] if params[:time_zone]

    @user = User.find(session[:user_id])
    if @user.update_attributes(user)
      session[:locale] = params[:locale] if params[:locale]
      render json: @@response
    else
      @@response[:error] = @user.errors.each { |a, m| add_error a, m}
      render json: @@response
    end
  end

  # GET/users/:id
  def show
    @@response[:data] = User.select("email, name, locale, time_zone, passive_at").find(params[:id])
    render json: @@response
  end

  # GET/users
  def index
    @@response[:data] = User.select("email, name, locale, time_zone, passive_at").all
    render json: @@response
  end
end
