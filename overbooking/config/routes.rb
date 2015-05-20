Overbooking::Engine.routes.draw do
  root 'welcome#index'

  resources :related_hotels do
    member do
      post :drop_related
      post :add_related
      get :search
    end
  end
end
