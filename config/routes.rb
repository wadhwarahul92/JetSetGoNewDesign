Rails.application.routes.draw do

  devise_for :users

  namespace :operators do

    get '/' => 'welcome#index'

    get 'sign_in' => 'welcome#log_in', as: :sign_in

    get 'sign_up' => 'welcome#sign_up', as: :sign_up

    post 'sign_in' => 'welcome#create_sign_in', as: :operator_sign_in

    post 'sign_up' => 'welcome#create_sign_up', as: :operator_sign_up

    resources :aircrafts do
      resources :aircraft_images
    end

  end

  namespace :api do
    namespace :v1 do
      get 'ios_app_version' => 'base#index'
      get 'raise_support_issue' => 'base#raise_support'
    end
  end

  namespace :organisations do

    get '/' => 'welcome#index'

    get 'sign_up' => 'welcome#create'

    get 'sign_in' => 'welcome#log_in'

    post 'sign_up' => 'welcome#create_'

    get 'settings' => 'welcome#setting'

    post 'sign_in' => 'operators#log_in_'

    get ':organisation_id/operators/admin' => 'operators#admin'

    post ':organisation_id/operators/create_admin' => 'operators#create_admin'

    resources :aircrafts do
      resources :aircraft_images
    end

    resources :forum_topics do
      resources :forum_topic_comments
    end
    resources :operators

    resources :aircraft_unavailabilities
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get 'dashboard' => 'welcome#dashboard', as: 'dashboard'
    post 'sign_in' => 'welcome#log_in', as: 'sign_in'
    get '/purchased_seat/:date' => 'jetsteal_seats#purchased_seat'

    resources :cities

    resources :airports

    resources :operators

    resources :aircraft_types

    resources :organisations

    resources :aircrafts do
      resources :aircraft_images
    end

    resources :distances

    resources :jetsteals do
      member do
        get 'launch'
        put 'unlaunch_'
      end
      resources :jetsteal_seats
    end

    resources :models do

      resources :model_attributes

    end

  end

  resources :airports do
    collection do
      get 'all_names'
    end
  end

  resources :aircraft_types

  resources :jetsteal_subscriptions

  namespace :jetsteals do
    get '/' => 'welcome#index'
    get 'list' => 'lists#index', as: 'jetsteals'
    get 'get_list' => 'lists#get_list'
    get ':id' => 'lists#show', as: 'jetsteal'
    get ':jetsteal_id/jetsteal_seats' => 'jetsteal_seats#index'

    resources :jetsteals do

      collection do
        get 'latest_image'
      end

      member do
        get 'buy_as_whole'
      end
    end

  end


  post 'payment_transactions/create' => 'payment_transactions#create'

  post 'payment_transactions/success' => 'payment_transactions#success'

  post 'payment_transactions/cancel' => 'payment_transactions#cancel'

  post 'payment_transactions/failure' => 'payment_transactions#failure'

  get 'payment_success' => 'payment_transactions#payment_success'

  get 'payment_failure' => 'payment_transactions#payment_failure'

  root 'jetsteals/welcome#index'

end