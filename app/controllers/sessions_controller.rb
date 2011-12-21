class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])

      user = User.select('id, name, email').find_by_email(params[:email])

      @@response[:user] = user

      apps = Array.new
      user.get_apps.each do |a|
        apps += [:sys_name => a.sys_name, :department => a.sys_department]
      end
      @@response[:user][:apps] = apps

      privileges = Array.new
      user.get_privileges.each do |p|
        privileges += [p.sys_name]
      end
      @@response[:user][:privileges] = privileges

    else
      @@response[:success] = false
    end

    render json:  @@response, callback: params[:callback]
  end

  def destroy
    render :json => session[:user_id]
  end

  def register
    @@response[request_forgery_protection_token] = form_authenticity_token
    @@response['tenant'] = Tenant.select('id, host').find_by_host!(request.host)
    render json: @@response, callback: params[:callback]
  end
end
