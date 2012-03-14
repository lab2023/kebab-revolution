KebabServerRor::Application.routes.draw do

  #pages
  match 'index' => 'pages#index'

  #os
  match 'login'   => 'os#login'
  match 'desktop' => 'os#desktop'
  match 'app_runner' => 'os#app_runner'
  post 'os/missing_translation'

  resources :subscriptions do
    collection do
      get 'paypal_recurring_payment_success'
      get 'paypal_recurring_payment_failed'
      get 'paypal_credential'
      get 'next_subscription'
      get 'payments'
      get 'plans'
      get 'limits'
    end
  end

  resources :sessions
  resources :passwords
  resources :feedback
  resources :users do
    collection do
      post 'enable'
      post 'disable'
    end
  end

  resources :tenants do
    get :valid_host
    get :tests
  end

  root to: "pages#index", :constraints => {:subdomain => "www"}
  root to: "os#login"
end
