Web::Application.routes.draw do

  resources :animal_activity_observations
  resources :animal_activity_types
  resources :animal_categories
  resources :animal_species

  resources :hunting_plots, shallow: true do
    member do
      get 'edit_location'
      get 'manage'
    end
    resources :named_animals, as: 'named_animals', controller: 'hunting_plot_named_animals', :only => [:index, :create, :new] do
    end
    resources :user_accesses, as: 'user_accesses', controller: 'hunting_plot_user_accesses', :only => [:index, :create, :new] do
    end
    resources :locations, as: 'locations', controller:'hunting_locations', :only => [:index, :create, :new] do
    end
    resources :user_access_requests, as: 'user_access_requests', controller:'hunting_plot_user_access_requests', :only => [:index, :create, :new] do
    end
  end

  resources :hunting_plot_named_animals, :except => [:index, :create, :new]
  resources :hunting_plot_user_accesses, :except => [:index, :create, :new]
  resources :hunting_plot_user_access_requests, :except => [:index, :create, :new] do
    member do
      patch 'accept'
      patch 'decline'
    end
    collection do
      get 'review'
    end
  end

  resources :hunting_locations, shallow: true, :except => [:index, :create, :new] do
    resources :schedules, as: 'schedules', controller:'hunting_location_schedules', :only => [:index, :create, :new] do
    end
  end

  resources :hunting_location_schedules, :except => [:index, :create, :new]

  resources :sessions, only: [:new, :create, :destroy]
  resources :users
  resources :user_invitations

  resources :user_network_categories

  resources :user_networks, shallow: true do
    resources :members, as:'members', controller: 'composite_network_members', :only => [:index, :create, :new] do
    end
  end

  resources :composite_network_members, :except => [:index, :create, :new]

  resources :user_network_subscriptions do
    collection do
      get 'manage'
      get 'child_networks/:id' => 'user_network_subscriptions#child_networks', as: :child_list
      post 'subscribe' => 'user_network_subscriptions#add_subscription', as: :add
    end
    member do
      delete 'unsubscribe' => 'user_network_subscriptions#remove_subscription', as: :remove
    end
  end

  resources :user_posts do
    collection do
      get 'feed_items'
    end
  end
  resources :user_relationships

  resources :relationship_requests

  resources :friends, :only => [:show, :new, :edit, :update, :index, :destroy] do
    post 'search', on: :new, to: 'friends#new_friend_search'
    collection do
      resources :requests, as: 'friend_requests', controller: 'friend_requests', :only => [:index, :show] do
        patch 'accept', on: :member
        patch 'reject', on: :member
      end
    end
  end

  get '/hunting_app/:hunting_plot_id', to: 'hunting_app#landing_page', as: :hunting_app
  get '/hunting_app/:hunting_plot_id/home', to: 'hunting_app#home', as: :hunting_app_home
  get '/hunting_app/:hunting_plot_id/map', to: 'hunting_app#map', as: :hunting_app_map
  post '/hunting_app/:hunting_plot_id/activity', to: 'hunting_app#activity', as: :hunting_app_activity
  get '/hunting_app/:hunting_plot_id/conditions', to: 'hunting_app#conditions', as: :hunting_app_conditions
  post '/hunting_app/:hunting_plot_id/checkin', to: 'hunting_app#check_in', as: :hunting_app_checkin

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
