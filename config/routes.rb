Rails.application.routes.draw do
  # use_doorkeeper
  # # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # Defines the root path route ("/")
  # # root "articles#index"
  # devise_for :users, controllers: {
  #   sessions: 'users/sessions'
  # }
  Rails.application.routes.default_url_options[:host] = "XXX"

  use_doorkeeper 

  scope module: :api, defaults: { format: :json }, path: 'api' do
    scope module: :v1 do
      resources :containers
      resources :customers
      resources :users
      resources :activities
      resources :repair_lists
      post '/auth/sign_in', to: "authentication#sign_in"
      post '/auth/password/new', to: "authentication#reset_password_token"
      put '/auth/password', to: "authentication#update_password"
      delete '/auth/sign_out', to: "authentication#sign_out"
      get '/containers/:id/activities', to: "activity#index"
       devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions',
        passwords: 'api/v1/users/passwords',
       }
       devise_scope :user do
        post "users/reset_password_token" => "users/passwords#reset_password_token"
       end
    end
  end
end
