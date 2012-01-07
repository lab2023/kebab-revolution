KebabServerRor::Application.routes.draw do
  match 'desktop'           => 'pages#desktop'
  match 'login'             => 'pages#login'
  match 'plan'              => 'pages#plan'
  match 'register'          => 'pages#register'

  get    "tenants/bootstrap"
  get    "tenants/valid_host"
  get    "tenants/tests"

  resource :sessions
  resource :passwords
  resource :tenants
  resource :feedback

  root :to => 'pages#login'
end
