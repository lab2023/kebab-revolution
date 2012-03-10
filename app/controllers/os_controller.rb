# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT
#
# Os Controller
class OsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :authenticate, only: [:login, :missing_translation]

  # GET/os/desktop
  def desktop
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale]
    @bootstrap = bootstrap
  end

  # GET/os/login
  def login
    @bootstrap = bootstrap
  end

  # GET/os/login
  def app_runner
    @bootstrap = bootstrap
  end

  # POST/pages/missing_translation
  def missing_translation
    logger.fatal params[:missing]
    render json: @response
  end
end
