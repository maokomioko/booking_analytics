Overbooking::Engine.routes.draw do
  root 'related_hotels#index'

  resources :directions do
    member do
      get :markers
      post 'notify_partner/:partner_id', action: :notify_partner, as: :notify_partner
    end
  end

  resources :partners do
    member do
      post :enable
      post :disable
    end
  end

  resources :reservations do
    collection do
      get :search
    end
  end
end
