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

    resources :operators do
      collection do
        get 'forgot_password'
        post 'forgot_password_'
      end
    end

    resources :aircraft_unavailabilities

    resources :trips do
      member do
        get 'get_enquiry'
        post 'send_quote'
      end
      collection do
        get 'all_events'
      end
    end

    resources :activities

    resources :jsg_updates

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

    resources :watch_hours

    resources :notams

    resources :jsg_updates

    resources :quotes

    resources :aircrafts do
      member do
        put :admin_approve
      end
      resources :aircraft_images
    end

    resources :distances

    resources :jetsteals do
      member do
        get 'launch'
        put 'unlaunch_'
        put 'send_emails_'
      end
      resources :jetsteal_seats
    end

    resources :models do

      resources :model_attributes

    end

    resources :taxes

  end

  resources :airports do
    collection do
      get 'all_names'
    end
  end

  resources :trips do
    collection do
      post 'enquire'
    end
  end

  resources :cities

  resources :aircraft_types

  resources :jetsteal_subscriptions do
    member do
      get 'unsubscribe'
    end
  end

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

  #get current_user
  get 'current_user' => 'welcome#current_user_'

  post 'sign_in_' => 'welcome#sign_in_'

  delete 'sign_out_' => 'welcome#sign_out_'

  post 'sign_up_' => 'welcome#sign_up_'

  resources :templates do
    collection do
      get 'sign_in_modal'
      get 'sign_up_modal'
      get 'index'
      get 'search'
      get 'about_us'
      get 'jet_set_wed'
      get 'heli_set_go'
      get 'jet_set_yatra'
      get 'media'
      get 'jet_setters'
      get 'contact_us'
      get 'our_edge'
      get 'join_us'
      get 'terms_of_use'
      get 'privacy_policy'
      get 'enquiry'
    end
  end

  resources :searches

  ######
  # Highly specific url, to be changed later
  # GET aircrafts for ids
  ######
  post 'aircrafts' => 'aircrafts#index'
  #################

  ########
  #Overridden routes for angular js
  #########

  get 'about_us' => 'route_overrides#welcome_index'
  get 'jet_set_wed' => 'route_overrides#welcome_index'
  get 'heli_set_go' => 'route_overrides#welcome_index'
  get 'jet_set_yatra' => 'route_overrides#welcome_index'
  get 'media' => 'route_overrides#welcome_index'
  get 'jet_setters' => 'route_overrides#welcome_index'
  get 'contact_us' => 'route_overrides#welcome_index'
  get 'our_edge' => 'route_overrides#welcome_index'
  get 'join_us' => 'route_overrides#welcome_index'
  get 'terms_of_use' => 'route_overrides#welcome_index'
  get 'privacy_policy' => 'route_overrides#welcome_index'


  root 'welcome#index'

end
