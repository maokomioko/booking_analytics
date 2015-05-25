Overbooking::Engine.routes.draw do
  root 'welcome#index'

  resources :directions do
    member do
      get :markers
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
end
