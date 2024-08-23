Rails.application.routes.draw do
  resources :reading_sessions
  get 'home/index'

  resources :producers do
    collection do
      get :build_work, format: :turbo_stream
      get :select_work, format: :turbo_stream
    end
  end

  resources :publishers

  resources :works do
    collection do
      # combined forms
      get :build_producer, format: :turbo_stream
      get :select_producer, format: :turbo_stream
      get :build_publisher, format: :turbo_stream
      get :select_publisher, format: :turbo_stream
      get :build_tag, format: :turbo_stream
      get :select_tag, format: :turbo_stream
      get :build_parent, format: :turbo_stream
      get :select_parent, format: :turbo_stream
    end

    # separate forms
    resources :quotes
    resources :notes
    resources :reading_sessions
  end

  get "quotes", to: "quotes#general_index", as: "quotes"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
