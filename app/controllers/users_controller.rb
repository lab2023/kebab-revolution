# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Users Controller
class UsersController < ApplicationController
  skip_before_filter :authorize, :except => [:create]

  # GET/users
  def index
    owner_id =  User.find(current_tenant.subscription.user_id)
    @@response[:data] = User.select("id, email, name, locale, time_zone, passive_at").where("id != ?", owner_id).all
    render json: @@response
  end

  # GET/users/:id
  def show
    @@response[:data] = User.select("id, email, name, locale, time_zone, passive_at").find(params[:id])
    render json: @@response
  end

  #POST/users
  def create
    user_hash = Hash.new
    user_hash[:email]     = params[:email]
    user_hash[:name]      = params[:name]
    user_hash[:locale]    = I18n.locale.to_s
    user_hash[:time_zone] = Time.zone.to_s.slice(12..-1)
    new_password = rand(10000000000000).floor.to_s(36)
    user_hash[:password]  = new_password
    user_hash[:password_confirmation] = new_password

    User.transaction do
      @new_user = User.new(user_hash)
      @new_user.roles << Role.find_by_name('User')
      if !reach_user_limit? && @new_user.save
        # KBBTODO #75 delay job integration
        UserMailer.invite(@new_user).deliver
        @@status = :created
      else
        @@response[:success] = @new_user.errors
        @@status = :unprocessable_entity
      end
    end

    render json: @@response, status: @@status
  end

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

  #POST/users/active
  def active
    @user = User.find(params[:id])
    if !reach_user_limit? && @new_user.save && is_owner(params[:id]) && @user.update_attribute(:passive_at, nil)
      render json: @@response
    else
      render json: {success: false}
    end
  end

  #POST/users/passive
  def passive
    @user = User.find(params[:id])
    if is_owner params[:id] && @user.update_attribute(:passive_at, Time.zone.now)
      render json: @@response
    else
      render json: {success: false}
    end
  end
end
