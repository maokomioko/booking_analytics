require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :views_data do
      collection do
        get :get_views
        get :get_rejections
        get :get_destinations
        get :get_sources
      end
    end
  end

  mount Graph::Engine, at: '/graph'
  mount Overbooking::Engine, at: '/overbooking'

  authenticate :user, ->(u) { u.role == 'admin' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :actions do
    get '/', action: :index
    get '/:user_id', action: :show, as: :show
  end

  resources :calendar, controller: :calendar

  resources :channel_manager, contoller: 'channel_manager' do
    collection do
      post :update_prices
    end
    member do
      get :match_plans
    end
  end

  resource :company, except: [:destroy] do
    resources :users, only: [:index, :destroy]
  end

  namespace :hotels do
    get :search, action: :search, as: :search
  end

  resources :rooms, only: [:update] do
    put :bulk_update, on: :collection
  end

  resources :related_hotels, only: [:index, :edit] do
    member do
      post :drop
      post :add
      get :search
    end
  end
  resources :reservations, only: :index

  resources :settings, only: [:index, :edit, :update]

  namespace :wizard do
    (1..5).to_a.each do |i|
      action = "step#{ i }".to_sym
      action_post = "step#{ i }_post".to_sym

      get action, action: action, as: action
      post action_post, action: action_post, as: action_post
    end

    get :complete, action: :complete, as: :complete
  end

  root to: 'calendar#index'
  devise_for :users, controllers: {
    registrations: 'registrations',
    passwords: 'passwords',
    invitations: 'invitations',
    sessions: 'sessions'
  }
end
