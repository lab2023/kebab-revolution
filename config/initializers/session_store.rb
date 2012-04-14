# Be sure to restart your server when you modify this file.

if Rails.env == 'production'
  KebabServerRor::Application.config.session_store :cookie_store, key: '_kebab-server-ror_session', :domain => ".kebab.com"
else
  KebabServerRor::Application.config.session_store :cookie_store, key: '_kebab-server-ror_session', :domain => ".kebab.local"
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# KebabServerRor::Application.config.session_store :active_record_store
