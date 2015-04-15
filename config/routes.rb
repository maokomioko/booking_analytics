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

  authenticate :user, ->(u) { u.role == 'admin' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :calendar, controller: :calendar do
    collection do
      get :demo
    end
  end

  resources :channel_manager, contoller: 'channel_manager' do
    collection do
      post :update_prices
    end
  end

  resource :company, except: [:destroy] do
    resources :users, only: [:index, :destroy]
  end

  resources :settings, only: [:index, :edit, :update]

  root to: 'calendar#index'
  devise_for :users, controllers: {
    registrations: 'registrations',
    passwords: 'passwords',
    invitations: 'invitations'
  }
end
