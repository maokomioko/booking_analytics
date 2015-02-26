Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    mount Graph::Engine, at: '/graph'

    resources :views_data do
      collection do
        get :get_views
        get :get_rejections
        get :get_destinations
        get :get_sources
      end
    end
  end

  resources :calendar, controller: :calendar

  resources :channel_manager, contoller: 'channel_manager' do
    collection do
      post :update_prices
    end
  end

  root to: 'calendar#index'
  devise_for :users
end
