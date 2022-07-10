Rails.application.routes.draw do
  get 'dashboard', to: 'dashboard#index'
  resources :rooms
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "rooms#index"
end
