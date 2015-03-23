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

  root to: 'calendar#index'
  devise_for :users, controllers: { registrations: 'registrations', passwords: 'passwords' }

  get :no_company, controller: :application
end
