Rails.application.routes.draw do

  devise_for :users

  namespace :operators do

    get '/' => 'welcome#index'

    get 'sign_in' => 'welcome#log_in', as: :sign_in

    get 'sign_up' => 'welcome#sign_up', as: :sign_up

    post 'sign_in' => 'welcome#create_sign_in', as: :operator_sign_in

    post 'sign_up' => 'welcome#create_sign_up', as: :operator_sign_up

  end

  namespace :api do
    namespace :v1 do
      get 'ios_app_version' => 'base#index'
      get 'raise_support_issue' => 'base#raise_support'
    end
  end

  namespace :admin do
    get '/' => 'welcome#index'
    get 'dashboard' => 'welcome#dashboard', as: 'dashboard'
    post 'sign_in' => 'welcome#log_in', as: 'sign_in'
    get '/paid_seat/:date' => 'jetsteal_seats#paymented_seat'

    resources :cities

    resources :airports

    resources :aircraft_types

    resources :aircrafts do
      resources :aircraft_images
    end

    resources :distances

    resources :jetsteals do
      member do
        get 'launch'
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
      member do
        get 'buy_as_whole'
      end
    end

  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  post 'payment_transactions/create' => 'payment_transactions#create'

  post 'payment_transactions/success' => 'payment_transactions#success'

  post 'payment_transactions/cancel' => 'payment_transactions#cancel'

  post 'payment_transactions/failure' => 'payment_transactions#failure'

  get 'payment_success' => 'payment_transactions#payment_success'

  get 'payment_failure' => 'payment_transactions#payment_failure'

  root 'jetsteals/welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
