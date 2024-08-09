Rails.application.routes.draw do
  resources :publishers
  get 'home/index'
  get 'home/append'

  resources :producers do
    collection do
      get :build_work, format: :turbo_stream
      get :select_work, format: :turbo_stream
    end
  end


  resources :works do
    collection do
      get :build_producer, format: :turbo_stream
      get :select_producer, format: :turbo_stream

      get :build_publisher, format: :turbo_stream
      get :select_publisher, format: :turbo_stream

      get :build_tag, format: :turbo_stream
      get :select_tag, format: :turbo_stream
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
