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

  resources :rooms, only: [:update] do
    put :bulk_update, on: :collection
  end

  resources :reservations, only: :index

  resources :settings, only: [:index, :edit, :update]

  root to: 'calendar#index'
  devise_for :users, controllers: {
    registrations: 'registrations',
    passwords: 'passwords',
    invitations: 'invitations',
    sessions: 'sessions'
  }
end
