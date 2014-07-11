Web::Application.routes.draw do

  resources :animal_activity_observations
  resources :animal_activity_types
  resources :animal_categories
  resources :animal_species
  resources :hunting_locations
  resources :hunting_plots do
    member do
      get 'edit_location'
    end
  end

  resources :hunting_plot_named_animals do
    collection do
      post 'search'
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :user_relationships
  resources :user_hunting_plot_accesses
  resources :user_posts do
    collection do
      post 'status'
    end
  end
  resources :relationship_requests
  resources :friends do
    post 'search', on: :new, to: 'friends#new_friend_search'
  end

  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get '/help', to: 'static_pages#help'

  get '/map/hunting_plot/:id' => 'map#hunting_plot', as: :plot_map
  get '/network_panel/:network_id' => 'static_pages#network_panel', as: :network_panel
  get '/test' => 'static_pages#test', as: :test

  root to: 'static_pages#home'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
