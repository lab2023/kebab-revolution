# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT
#
# Pages Controller
class PagesController < ApplicationController
  layout "pages"

  skip_before_filter :tenant
  skip_before_filter :authenticate
  skip_before_filter :authorize

  # GET/pages/index
  def index
  end

  # GET/pages/plans
  def plans
  end

  # GET/pages/register
  def register
    @plan_id = params[:plan].to_i
    redirect_to :action => :plans unless (1..5).member?(@plan_id.to_i)
  end

  # POST/pages/missing_translation
  def missing_translation
    logger.fatal params[:missing]
    render json: @@response
  end
end
