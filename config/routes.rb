Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "auth/login"
      get "auth/register"

      resources :venues, only: [:index, :show] do
        member do
          get 'schedules'
        end
      end

      resources :courts, only: [:index, :show] do
        member do
          get 'availability'
          get 'schedules'
        end
      end

      resources :schedules, only: [:index, :show]

      resources :bookings, only: [:index, :create, :show] do
        member do
          patch 'cancel'
        end
      end
    end
  end
  namespace :admin do
    resources :accounts
    resources :courts
    resources :users
    resources :venues
    resources :schedules
    resources :bookings

    root to: "accounts#index"
  end

  # Devise routes
  # devise_for :users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Root route
  root "pages#home"
end
