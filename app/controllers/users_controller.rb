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
    owner_id =  @current_tenant.users.find(@current_tenant.subscription.user_id)
    @response[:data] = @current_tenant.users.select("id, email, name, locale, time_zone, disabled").where("id != ?", owner_id).all
    render json: @response
  end

  # GET/users/:id
  def show
    #KBBTODO add success
    render json: @current_tenant.users.select("id, email, name, locale, time_zone, disabled").find(params[:id])
  end

  #POST/users
  def create
    user_hash = Hash.new
    user_hash[:email]     = params[:email].strip
    user_hash[:name]      = params[:name.strip]
    user_hash[:locale]    = I18n.locale.to_s
    user_hash[:time_zone] = Time.zone.to_s.slice(12..-1)
    new_password = rand(10000000000000).floor.to_s(36)
    user_hash[:password]  = new_password
    user_hash[:tenant_id] = @current_tenant.id

    User.transaction do
      @new_user = User.new(user_hash)
      @new_user.roles << @current_tenant.roles.find_by_name('User')
      if !reach_user_limit? && @new_user.save
        # KBBTODO #75 delay job integration
        UserMailer.invite(@new_user, @current_tenant.subdomain).deliver
        @status = :created
      else
        add_error 'email', @new_user.errors[:email] unless @new_user.errors[:email].blank?
        @response[:success] = false
        @status = :unprocessable_entity
      end
    end

    render json: @response, status: @status
  end

  # PUT/users/:id
  def update
    user = Hash.new
    user[:email]     = params[:email].strip     if params[:email]
    user[:name]      = params[:name].strip      if params[:name]
    user[:locale]    = params[:locale]    if params[:locale]
    user[:time_zone] = params[:time_zone] if params[:time_zone]

    @user = @current_tenant.users.find(session[:user_id])
    if @user.update_attributes(user)
      session[:locale] = params[:locale] if params[:locale]
      render json: @response
    else
      @response[:error] = @user.errors.each { |a, m| add_error a, m}
      render json: @response
    end
  end

  #POST/users/enable
  def enable
    @user = @current_tenant.users.find(params[:id])
    if !reach_user_limit? && is_owner(session[:user_id]) && @user.update_attribute(:disabled, false)
      # KBBTODO #75 delay job integration
      UserMailer.enable(@user).deliver
      render json: @response
    else
      render json: {success: false}
    end
  end

  #POST/users/disable
  def disable
    @user = @current_tenant.users.find(params[:id])
    if is_owner(session[:user_id]) && @user.update_attribute(:disabled, true)
      # KBBTODO #75 delay job integration
      UserMailer.disable(@user).deliver
      render json: @response
    else
      render json: {success: false}
    end
  end
end
