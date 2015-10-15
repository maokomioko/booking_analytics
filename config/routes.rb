require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  mount Graph::Engine, at: '/graph'

  authenticate :user, ->(u) { u.role == 'admin' } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :actions do
    get '/', action: :index
    get '/:user_id', action: :show, as: :show
  end

  resources :calendar, controller: :calendar

  resources :channel_manager, contoller: 'channel_manager', except: [:new, :edit] do
    collection do
      post :update_prices
    end
    member do
      get :match_plans
    end
  end

  resource :company, except: [:new, :show, :destroy] do
    resources :users, only: [:index, :destroy]
  end

  resources :hotels, only: :show do
    collection do
      get :search, action: :search, as: :search
      get :markers, action: :markers, as: :markers
    end
  end

  scope 'hotels/:hotel_id', as: :hotel do
    resources :contacts
  end
  get 'hotels/contacts/by_hotel', controller: :contacts, action: :by_hotel

  resources :rooms, only: [:update] do
    put :bulk_update, on: :collection
  end

  resources :related_hotels do
    collection do
      get :search
      get :enable
      get :disable
      delete :destroy
    end
  end

  resources :reservations do
    post :search, on: :collection
    post 'notify_partner/:partner_id', action: :notify_partner, as: :notify_partner
  end

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
