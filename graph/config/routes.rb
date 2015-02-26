Graph::Engine.routes.draw do
  resources :graph do
    collection do
      get :holder
    end
  end
end