KebabServerRor::Application.routes.draw do
  get "users/update_profile"

  match 'desktop'           => 'pages#desktop'
  match 'login'             => 'pages#login'
  match 'plan'              => 'pages#plan'
  match 'register'          => 'pages#register'

  get     "tenants/bootstrap"
  get     "tenants/valid_host"
  get     "tenants/tests"

  get     "users/get_profile"
  post    "users/update_profile"

  resource :sessions
  resource :passwords
  resource :tenants
  resource :feedback

  root :to => 'pages#login'
end
