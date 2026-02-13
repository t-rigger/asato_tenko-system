Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Development tools
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Public QR display page (root)
  root "pages#qr_display"

  # Admin authentication (Stateless)
  namespace :admins do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    match 'logout', to: 'sessions#destroy', via: [:get, :delete]
    
    # Dashboard route is removed as per user request
    # get 'dashboard', to: 'dashboard#index'
  end
end
