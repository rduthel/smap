Rails.application.routes.draw do

  root to: 'pages#home'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :cars, only: [:index, :show]

  resources :additional_drivers, only: [:new, :edit, :update, :create, :destroy]

  resources :addresses, only: [:new, :edit, :update, :create, :destroy]

  resources :slots, only: [:new, :edit, :update, :create, :destroy]

  #Estimation et souscription

  get "/cars/:id/estimation", to: "cars#estimation", as: "estimation"
  get "/cars/:id/souscription", to: "cars#souscription", as: "souscription"

  #Dashboard routes
  get "/dashboard", to: "dashboards#show"
  get "/dashboard/bill", to: "dashboards#bill"
  get "/dashboard/slot", to: "dashboards#slot"

  #Profil routes
  get "/profil", to: "driver_profiles#profile"
  get "/profil/edit", to: "driver_profiles#edit"
  patch "/profil", to: "driver_profiles#update"
end
