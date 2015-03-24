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

  authenticate :user, lambda { |u| u.role == 'admin' } do
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

  resource :setting, except: [:show, :new, :destroy]

  root to: 'calendar#index'
  devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords' }

  get :no_company, controller: :application
end
