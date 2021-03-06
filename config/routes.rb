Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'   
  root 'home#index'
  resources :users
  resources :gaccounts
  resources :sessions
  resources :serial
  resources :tags
  resources :dealers


  resources :groupon_products do
    collection do
      post 'upload'
    end
  end


  resources :products_info do
    collection do
      post 'upload'
      get 'upload_progress'
    end
  end


  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'


  namespace :api do
    namespace :v1 do
      resources :products_info do
        collection do
          get 'serials'
          get 'check_registration_user_info'
        end
      end
      resources :districts do
        collection do
          get 'cities'
          get 'provinces'
          get 'cities_by_province'
          get 'province_by_cities'
          get 'by_dealer'
        end
      end
    end
  end

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
