Overbooking::Engine.routes.draw do
  root 'welcome#index'

  resources :related_hotels do
    post :drop_related, on: :member
  end
end
