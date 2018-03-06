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
  get "/dashboard", to: "dashboards#show", as: :dashboard
  get "/dashboard/bill", to: "dashboards#bill", as: :dashboard_bill
  get "/dashboard/slot", to: "dashboards#slot", as: :dashboard_slot
  get "/profil", to: "dashboards#profile", as: :dashboard_profile

  #Profil routes
  get "/profil/edit", to: "driver_profiles#edit"
  patch "/profil", to: "driver_profiles#update"
end
