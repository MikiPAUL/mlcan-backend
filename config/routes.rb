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
      #users
      get '/me', to: "users#profile"
      
      #repair_lists
      post '/repair_lists/versions', to: "repair_lists#create_version"
      get '/repair_lists/download', to: 'repair_lists#export_xlsx'
      get '/repair_lists/upload', to: 'repair_lists#upload'
      get '/activity/:id', to: 'activity_repair_list#index'

      #activity_repair_lists
      get '/activity/:id/repair_lists', to: 'activity_repair_list#index'
      post '/activity/:id/repair_lists', to: 'activity_repair_list#create'
      put '/repair_lists/:id', to: 'activity_repair_list#put'
      get '/activity_repair_lists/:id', to: "activity_repair_list#show"
      
      #activities
      get '/container/:id/activities', to: "activities#index"
      post '/container/:id/activities', to: "activities#create"
      get '/activities/:id', to: "activities#show"
      put '/activities/:id', to: "activities#update"
      
      #comments
      get '/container/:id/comments', to: "comments#index"
      post '/container/:id/comments', to: "comments#create"
      
      #logs 
      get '/container/:id/logs', to: "logs#index"

      #containers
      put '/containers/approve', to: "containers#customer_approve"

      resources :users
      devise_for :users
      devise_scope :user do
        post '/auth/sign_in', to: "authentication#sign_in"
        post '/auth/password/new', to: "authentication#reset_password_token"
        put '/auth/password', to: "authentication#update_password"
        delete '/auth/sign_out', to: "authentication#sign_out"
      end
      resources :repair_lists
      resources :containers
      resources :customers
    end
  end
end
