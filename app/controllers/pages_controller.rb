# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT
#
# Pages Controller
class PagesController < ApplicationController
  skip_around_filter :tenant,       only: [:index, :register, :plans, :missing_translation]
  skip_before_filter :authenticate, only: [:index, :register, :plans, :missing_translation, :login]
  skip_before_filter :authorize

  # GET/pages/index
  def index
  end

  # GET/pages/desktop
  def desktop
    @bootstrap = bootstrap
  end

  # GET/pages/login
  def login
    @bootstrap = bootstrap
  end

  # GET/pages/plans
  def plans
    @plans = Plan.order("price")
  end

  # GET/pages/register
  def register
    @bootstrap = bootstrap false
  end

  # POST/pages/missing_translation
  def missing_translation
    logger.fatal params[:missing]
    render json: @@response
  end
end
