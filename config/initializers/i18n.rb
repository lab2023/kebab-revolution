# A simple exception handler that behaves like the default exception handler
# but additionally logs missing translations to a given log.
module I18n
  class << self
    def missing_translations_logger
      @@missing_translations_logger ||= Logger.new("#{Rails.root}/log/#{Rails.env}.log")
    end

    def missing_translations_log_handler(exception, locale, key, options)
      if I18n::MissingTranslation === exception
        missing_translations_logger.fatal("\033[0;37m#{Time.now.to_s(:db)}\033[0m [\033[31mFATAL\033[0m] pid:#{$$} \n #{exception.message} \n")
        return exception.message
      else
        raise exception
      end
    end
  end
end

I18n.exception_handler = :missing_translations_log_handler