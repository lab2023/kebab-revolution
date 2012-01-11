KebabServerRor::Application.routes.draw do

  match 'index'             => 'pages#index'
  match 'desktop'           => 'pages#desktop'
  match 'login'             => 'pages#login'
  match 'plans'             => 'pages#plans'
  match 'register'          => 'pages#register'

  resources :sessions
  resources :passwords
  resources :feedback
  resources :users
  resources :tenants do
    get :valid_host
    get :tests
  end

  root to: "pages#index"
end
