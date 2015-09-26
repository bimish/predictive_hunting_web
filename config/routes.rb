Rails.application.routes.draw do
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
    resources :user_groups, as: 'user_groups', controller:'user_groups', :only => [:index, :create, :new] do
    end
    get 'reservations/new', to: 'hunting_location_reservations#new'
    post 'reservations/create', to: 'hunting_location_reservations#create'
    get 'reservations', to: 'hunting_location_reservations#index'
  end

  resources :hunting_plot_named_animals, :except => [:index, :create, :new]
  resources :hunting_plot_user_accesses, :except => [:index, :create, :new]
  resources :hunting_plot_user_access_requests, :except => [:index, :create, :new] do
    member do
      patch 'accept'
      patch 'decline'
      patch 'notify'
    end
    collection do
      get 'review'
    end
  end

  resources :user_groups, shallow: true, :except => [:index, :create, :new] do
    resources :user_group_members, as: 'members', controller:'user_group_members', :only => [:index, :create, :new] do
      collection do
        get 'select'
        post 'set'
      end
    end
  end

  resources :hunting_locations, shallow: true, :except => [:index, :create, :new] do
    get 'reservations', to: 'hunting_location_reservations#index'
    get 'reservations/new', to: 'hunting_location_reservations#new'
    post 'reservations/create', to: 'hunting_location_reservations#create'
    #resources :schedules, as: 'schedules', controller:'hunting_location_schedules', :only => [:index, :create, :new] do
    #end
    resources :hunting_location_user_accesses, as: 'user_acccesses', controller:'hunting_location_user_accesses', :only => [:index, :create, :new] do
    end
    resources :hunting_location_user_group_accesses, as: 'user_group_accesses', controller:'hunting_location_user_group_accesses', :only => [:index, :create, :new] do
    end
  end

  resources :hunting_location_user_accesses, :except => [:index, :create, :new]
  resources :hunting_location_user_group_accesses, :except => [:index, :create, :new]

  resources :hunting_location_reservations, :except => [:index, :create, :new] do
    collection do
      match 'search/:hunting_plot_id' => 'hunting_location_reservations#search', :via => [:get, :post], as: :search
      get 'index/:hunting_plot_id', to: 'hunting_location_reservations#index', as: :index
    end
  end

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

  resources :hunting_mode_user_statuses, :only => [:new, :create]

  resources :password_resets

  # non-admin plot management
  scope "/plot_management/:hunting_plot_id", as:'plot_management', controller: 'plot_management' do
    root to:'plot_management#home'
    get 'members'
    get 'member_invitations'
    get 'user_groups'
    get 'stand_access'
    get 'stand_access/:hunting_location_id/edit', to: :edit_stand_access, as: :edit_stand_access
    patch 'stand_access/:hunting_location_id/update', to: :update_stand_access, as: :update_stand_access
    get 'stands_list'
    get 'stands_map'
    get 'stand_reservations'
    get 'named_animals'
    get 'activity_log'
  end

  # system admin stuff
  namespace :sys_admin do
    resources :plots
    resources :users
  end

  # hunting app routes
  get '/hunting_app/:hunting_plot_id', to: 'hunting_app#landing_page', as: :hunting_app
  get '/hunting_app/:hunting_plot_id/home', to: 'hunting_app#home', as: :hunting_app_home
  get '/hunting_app/:hunting_plot_id/stands', to: 'hunting_app#stands', as: :hunting_app_stands
  get '/hunting_app/:hunting_plot_id/map', to: 'hunting_app#map', as: :hunting_app_map
  get '/hunting_app/:hunting_plot_id/activity', to: 'hunting_app#activity', as: :hunting_app_activity
  post '/hunting_app/:hunting_plot_id/activity_record', to: 'hunting_app#activity_record', as: :hunting_app_activity_record
  post '/hunting_app/:hunting_plot_id/activity_history', to: 'hunting_app#activity_history', as: :hunting_app_activity_history
  get '/hunting_app/:hunting_plot_id/weather', to: 'hunting_app#weather', as: :hunting_app_weather
  get '/hunting_app/:hunting_plot_id/chat', to: 'hunting_app#chat', as: :hunting_app_chat
  get '/hunting_app/:hunting_plot_id/chat_refresh/:since_id', to: 'hunting_app#chat_refresh', as: :hunting_app_chat_refresh
  post '/hunting_app/:hunting_plot_id/chat_post', to: 'hunting_app#chat_post', as: :hunting_app_chat_post
  post '/hunting_app/:hunting_plot_id/checkin', to: 'hunting_app#check_in', as: :hunting_app_checkin
  get '/hunting_app/:hunting_plot_id/stand_checkin_dialog(/:hunting_location_id)', to: 'hunting_app#stand_checkin_dialog', as: :hunting_app_stand_checkin_dialog
  get '/hunting_app/:hunting_plot_id/stand_reservation_dialog/:hunting_location_id', to: 'hunting_app#stand_reservation_dialog', as: :hunting_app_stand_reservation_dialog
  post '/hunting_app/:hunting_plot_id/create_stand_reservation', to: 'hunting_app#create_stand_reservation', as: :hunting_app_create_stand_reservation
  get '/hunting_app/:hunting_plot_id/hunt_forecast', to: 'hunting_app#hunt_forecast', as: :hunting_app_hunt_forecast
  get '/hunting_app/:hunting_plot_id/hunt_forecast_month/:forecast_date', to: 'hunting_app#hunt_forecast_month', as: :hunting_app_hunt_forecast_month

  get '/hunting_app/:hunting_plot_id/stand_checkin', to: 'hunting_app#stand_checkin', as: :hunting_app_stand_checkin
  get '/hunting_app/:hunting_plot_id/stand_dialog/:hunting_location_id', to: 'hunting_app#stand_dialog', as: :hunting_app_stand_dialog

  # user sign in, sign up, sign out stuff
  get '/signup', to: 'users#new'
  get '/signin', to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get '/signout', to: 'sessions#destroy'

  # static stuff
  get '/help', to: 'static_pages#help'
  get '/home' => 'static_pages#home', as: :home

  get '/map/hunting_plot/:id' => 'map#hunting_plot', as: :plot_map
  get '/network_panel/:network_id' => 'static_pages#network_panel', as: :network_panel
  get '/test' => 'static_pages#test', as: :test

  # base route
  root to: 'static_pages#router'
end
