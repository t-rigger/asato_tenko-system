Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # rootをログイン画面に設定
  devise_scope :admin do
    root "admins/sessions#new"
  end

  devise_for :admins, :controllers => {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords'
  }

  devise_scope :user do
    get "users/registration", to: "omniauth_callbacks#new"
    get "users/registration/complete", to: "omniauth_callbacks#complete"
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }

  namespace :admins do
    scope :v1 do
      resources :dashboards, only: [:index]
      resources :users, only: %i(show edit update destroy)
    end
  end
end
