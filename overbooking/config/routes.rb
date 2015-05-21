Overbooking::Engine.routes.draw do
  root 'welcome#index'

  resources :related_hotels do
    member do
      post :drop_related
      post :add_related
      post :enable_overbooking
      post :disable_overbooking
      get :search
    end
  end
end
