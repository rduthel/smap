Rails.application.routes.draw do
  devise_for :users
  root to: 'cars#home'

  resources :cars, only: [:index, :show, :estimation, :subscription]

  get "/profil", to: "driver_profile#profil"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
