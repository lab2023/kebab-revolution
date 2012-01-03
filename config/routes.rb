KebabServerRor::Application.routes.draw do
  match 'desktop' => 'pages#desktop'
  match 'login' => 'pages#login'

  get    "tenants/bootstrap"
  get    "tenants/tests"

  resource :sessions
  resource :passwords
  resource :tenants

  root :to => 'pages#login'
end
