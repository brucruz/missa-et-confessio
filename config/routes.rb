Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "churches#index"

  resources :churches, only: [ :index, :new, :create, :show ] do
    resources :mass_schedules, only: [ :new, :create, :edit ] do
      collection do
        post :add_schedule
        match :bulk_update, via: [ :patch, :post ]
      end
    end
    resources :confession_schedules, only: [ :new, :create ]
    collection do
      get :search_address
    end
  end

  resources :addresses, only: [] do
    collection do
      get :search
      get :search_churches
    end
  end
end
