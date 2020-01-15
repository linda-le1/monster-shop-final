Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end
  # get "/merchants", to: "merchants#index"
  # get "/merchants/new", to: "merchants#new"
  # get "/merchants/:id", to: "merchants#show"
  # post "/merchants", to: "merchants#create"
  # get "/merchants/:id/edit", to: "merchants#edit"
  # patch "/merchants/:id", to: "merchants#update"
  # delete "/merchants/:id", to: "merchants#destroy"

  resources :items, except: [:new, :create]
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"
  # delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  patch '/cart/:item_id', to: 'cart#increment_decrement'

  get "/orders/new", to: "orders#new"
  post "/profile/orders", to: "orders#create"
  get '/profile/orders', to: 'orders#index'
  get "/orders/:id", to: "orders#show"
  patch "/orders/:id", to: "orders#update"

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show'

  get '/profile/edit', to:'users#edit'
  patch '/profile/edit', to:'users#update'
  get '/profile/orders/:id', to: 'orders#show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/profile', to: 'users#index'
    patch '/item_orders/:id', to: 'item_orders#update'
    get '/orders/:id', to: 'orders#show'
    get '/items', to: 'items#show'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    delete '/items/:id', to: 'items#destroy'
    patch 'items/:id', to: 'items#update'
    get '/items/:id/edit', to: 'items#edit'
    get '/coupons', to: 'coupons#index'
    get '/coupons/new', to: 'coupons#new'
    post '/coupons', to: 'coupons#create'
  end

  namespace :admin do
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    get '/merchants', to: 'merchants#index'
    get '/', to: 'dashboard#index'
    get '/profile/:id', to: 'users#show'
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    get '/merchants/:id', to: 'merchants#show'
    patch '/orders/:id', to: 'dashboard#update'
    patch '/merchants/:id', to: 'merchants#update'
  end

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'
  patch '/user/id', to: 'users#update'
end
