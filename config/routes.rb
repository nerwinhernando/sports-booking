Rails.application.routes.draw do
  # Letter Opener Web (development only)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # ============================================
  # DEVISE AUTHENTICATION (Global)
  # ============================================
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  # ============================================
  # GLOBAL ROUTES (Work with or without subdomain)
  # ============================================

  # Search functionality (available everywhere)
  get 'search', to: 'pages#search'

  # Public pages
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'

  # Public browsing
  resources :venues, only: [:index, :show]
  resources :bookings, only: [:index, :show]

  # ============================================
  # MAIN SITE ROUTES
  # ============================================
  constraints subdomain: '' do
    root 'pages#home', as: :main_root

    get 'search', to: 'pages#search'

    namespace :super_admin do
      get '/', to: 'dashboard#index', as: :root

      resources :accounts do
        member do
          patch :activate
          patch :deactivate
        end
      end

      resources :users, only: [:index, :show, :edit, :update] do
        collection do
          get :search
        end
        member do
          patch :toggle_active
        end
      end
    end

    namespace :super_admin_administrate do
      get '/', to: 'dashboard#index', as: :root
      get 'dashboard', to: 'dashboard#index'

      resources :accounts do
        member do
          patch :activate
          patch :deactivate
        end
      end

      resources :users do
        member do
          patch :toggle_active
        end
      end

      resources :bookings, only: [:index, :show]
      resources :venues, only: [:index, :show]
    end
  end

  # ============================================
  # TENANT ROUTES
  # ============================================
  constraints(lambda { |req| req.subdomain.present? && req.subdomain != 'www' }) do
    root 'pages#landing', as: :tenant_root

    namespace :admin do
      get '/', to: 'dashboard#index', as: :root
      get 'dashboard', to: 'dashboard#index'
    end

    namespace :staff do
      get '/', to: 'bookings#index', as: :root
    end
  end

  # ============================================
  # HEALTH & PWA
  # ============================================
  get "up" => "rails/health#show", as: :rails_health_check

  # ============================================
  # ERROR PAGES
  # ============================================
  match '/404', to: 'errors#not_found', via: :all
end
