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
      resources :comments
      get '/repair_lists/download', to: 'repair_lists#export_xlsx'
      get '/repair_lists/upload', to: 'repair_lists#upload'
      get '/activity/:id/repair_lists', to: 'activity_repair_list#index'
      post '/activity/:id/repair_lists', to: 'activity_repair_list#create'

      resources :repair_lists
      post '/auth/sign_in', to: "authentication#sign_in"
      post '/auth/password/new', to: "authentication#reset_password_token"
      put '/auth/password', to: "authentication#update_password"
      delete '/auth/sign_out', to: "authentication#sign_out"
      get '/container/:id/activities', to: "activities#index"
      post '/container/:id/activities', to: "activities#create"
      get '/container/:id/comments', to: "comments#index"
      post '/container/:id/comments', to: "comments#create"
      post '/repair_lists/versions', to: "repair_lists#create_version"
      get '/container/:id/logs', to: "activities#show_logs"
      get '/me', to: "users#profile"
      post '/repair_lists/versions', to: "repair_lists#create_version"

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
