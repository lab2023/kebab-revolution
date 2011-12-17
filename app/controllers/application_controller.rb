class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    set_i18n_locale
    check_tenant
  end

  @@response = {:success => true}

  protected
    attr_reader :current_tenant

    def check_tenant
      if Tenant.find_by_host(request.host) != nil
        @tenant = Tenant.current = Tenant.find_by_host!(request.host)
      else
        @@response = {:success => false}
        add_notice 'ERR', I18n.t('notice.invalid_tenant')
        render json: @@response, status: :not_found
      end
    end

    def add_notice type, message
      notice = [:type => type, :message => message]
      if @@response.has_key?(:notice)
        @@response[:notice] += notice unless @@response[:notice].include?(notice) || @@response[:notice] == notice
      else
        @@response[:notice] = notice
      end
    end

    def add_error id, message
      @@response[:success] = false
      error = [:id => id, :message => message]
      if @@response.has_key?(:error)
        @@response[:error] += error unless @@response[:error].include?(error) || @@response[:error] == error
      else
        @@response[:error] = error
      end
    end

    def set_i18n_locale
      I18n.locale = set_i18n_locale_from_param || set_i18n_locale_from_session || I18n.default_locale
    end

    def set_i18n_locale_from_param
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          params[:locale]
        end
      end
    end

    def set_i18n_locale_from_session
      if session[:locale]
        if I18n.available_locales.include?(session[:locale].to_sym)
          session[:locale]
        end
      end
    end
end
