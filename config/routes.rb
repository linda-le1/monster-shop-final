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
  # get "/merchants/:merchant_id/items", to: "items#index"
  # get "/merchants/:merchant_id/items/new", to: "items#new"
  # post "/merchants/:merchant_id/items", to: "items#create"

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end
  # get "/items", to: "items#index"
  # get "/items/:id", to: "items#show"
  # get "/items/:id/edit", to: "items#edit"
  # patch "/items/:id", to: "items#update"
  # delete "/items/:id", to: "items#destroy"
  # get "/items/:item_id/reviews/new", to: "reviews#new"
  # post "/items/:item_id/reviews", to: "reviews#create"

  resources :reviews, only: [:edit, :update, :destroy] do
  end
  # get "/reviews/:id/edit", to: "reviews#edit"
  # patch "/reviews/:id", to: "reviews#update"
  # delete "/reviews/:id", to: "reviews#destroy"

  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id', to: 'cart#increment_decrement'

  patch '/coupon', to: 'coupons#update'

  resources :orders, only: [:new, :show, :update] do
  end

  post '/profile/orders', to: 'orders#create'
  get '/profile/orders', to: 'orders#index'
  get '/profile/orders/:id', to: 'orders#show'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to:'users#edit'
  patch '/profile/edit', to:'users#update'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :merchant do

    get '/', to: 'dashboard#index'
    get '/profile', to: 'users#index'

    resources :item_orders, only: [:update] do
    end

    resources :orders, only: [:show] do
    end

    resources :items do
    end

    resources :coupons do
    end

  end

  namespace :admin do

    resources :users, only: [:index, :show, :update] do
    end

    resources :merchants, only: [:index, :show, :update] do
    end

    get '/', to: 'dashboard#index'
    get '/profile/:id', to: 'users#show'
    patch '/orders/:id', to: 'dashboard#update'
  end

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'
  # patch '/user/:id', to: 'users#update'
end
