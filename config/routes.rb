KebabServerRor::Application.routes.draw do

  match 'index'             => 'pages#index'
  match 'desktop'           => 'pages#desktop'
  match 'login'             => 'pages#login'
  match 'plans'             => 'pages#plans'
  match 'register'          => 'pages#register'

  get 'subscriptions/paypal_recurring_payment_success'
  get 'subscriptions/paypal_recurring_payment_failed'
  get 'subscriptions/paypal_credential'
  get 'subscriptions/next_subscription'
  get 'subscriptions/payments'

  resources :sessions
  resources :passwords
  resources :feedback
  resources :users do
    collection do
      post 'active'
      post 'passive'
    end
  end
  resources :tenants do
    get :valid_host
    get :tests
  end

  # KBBTODO #97
  root to: "pages#index"
end
