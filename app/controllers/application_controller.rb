class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_tenant

  @@response = {:success => true}

  protected
    attr_reader :current_tenant

    def check_tenant
      if Tenant.find_by_host(request.host) != nil
        @tenant = Tenant.current = Tenant.find_by_host!(request.host)
      else
        @@response[:success] = false
        add_notice 'ERR', 'Invalid tenant'
        render json: @@response
      end
    end

    def add_notice type, message
      notice = [:type => type, :message => message]
      if @@response.has_key?(:notice)
        @@response[:notice] += notice
      else
        @@response[:notice] = notice
      end
    end

    def add_error id, message
      @@response[:success] = false
      error = [:id => id, :message => message]
      if @@response.has_key?(:error)
        @@response[:error] += error
      else
        @@response[:error] = error
      end
    end
end
