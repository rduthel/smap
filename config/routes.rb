Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'cars#home'

  resources :cars, only: [:index, :show, :estimation, :subscription]


  get "/profil", to: "driver_profiles#profile"
  get "/profil/edit", to: "driver_profiles#edit"
  patch "/profil", to: "driver_profiles#update"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
