require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
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

  resources :hotels, only: :show do
    get :search, action: :search, as: :search, on: :collection
  end

  resources :rooms, only: [:update] do
    put :bulk_update, on: :collection
  end

  namespace :room_settings do
    put :bulk_update, action: :bulk_update, as: :bulk_update
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

  namespace :payments do
    get :details, action: :details
    post :update_status, action: :update_status
    get :transaction_result, action: :transaction_result

    post :modify_items, action: :modify_items
  end

  namespace :wizard do
    (1..5).to_a.each do |i|
      action = "step#{ i }".to_sym
      action_post = "step#{ i }_post".to_sym

      get "step/#{ i }", action: action, as: action, step: i
      post "step/#{ i }", action: action_post, as: action_post, step: i
    end

    get :complete, action: :complete, as: :complete
    get :setup_not_completed, action: :setup_not_completed, as: :setup_not_completed
  end

  root to: 'calendar#index'
  devise_for :users, controllers: {
    registrations: 'registrations',
    passwords: 'passwords',
    invitations: 'invitations',
    sessions: 'sessions'
  }
end
