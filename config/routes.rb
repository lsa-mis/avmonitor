Rails.application.routes.draw do
  get 'page/home'
  get 'dashboard', to: 'dashboard#index'
  post 'dashboard', to: 'dashboard#index'
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks", sessions: "users/sessions"} do
    delete 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
  end
  resources :rooms do
    resources :notes, module: :rooms
  end
  resources :notes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
 
  get '/connect_all_rooms', to: 'rooms#connect_all_rooms', as: 'connect'
  get '/refresh_room/:id', to: 'rooms#refresh_room', as: 'refresh'

  # Defines the root path route ("/")
  root "pages#home"
end
