Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :views_data do
        collection do
          get :get_views
          get :get_rejections
          get :get_destinations
          get :get_sources
        end
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
