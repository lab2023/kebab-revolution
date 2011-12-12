class ApplicationController < ActionController::Base
  protect_from_forgery

  @@response = {:success => true}

  before_filter do
     check_tenant
  end

  protected

    def check_tenant
        unless %w{www}.include?(request.subdomain)
          if Tenant.find_by_host(request.host) != nil
            @tenant = Tenant.current = Tenant.find_by_host!(request.host)
          else
            @@response[:success] = false
            render json: @@response
          end
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
