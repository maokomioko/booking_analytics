Graph::Engine.routes.draw do
  root to: 'hotels#index'

  resources :hotels, only: [:index] do
    collection do
      get :simple
      get :competitors
      get :cherry_pick
    end
  end
end