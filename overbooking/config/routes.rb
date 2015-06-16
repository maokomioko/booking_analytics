Overbooking::Engine.routes.draw do
  root 'related_hotels#index'

  resources :directions do
    member do
      get :markers
      post 'notify_partner/:partner_id', action: :notify_partner, as: :notify_partner
    end
  end

  resources :related_hotels do
    member do
      post :drop_related
      post :add_related
      post :enable_overbooking
      post :disable_overbooking
      get :search
    end
  end

  resources :reservations do
    collection do
      get :search
    end
  end
end
