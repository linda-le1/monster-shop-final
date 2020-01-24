Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id', to: 'cart#increment_decrement'

  patch '/coupon', to: 'coupons#update'

  resources :orders, only: [:new, :show, :update]

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

    resources :item_orders, only: [:update]

    resources :orders, only: [:show]

    resources :items

    resources :coupons

  end

  namespace :admin do

    resources :users, only: [:index, :show, :update]

    resources :merchants, only: [:index, :show, :update]

    get '/', to: 'dashboard#index'
    get '/profile/:id', to: 'users#show'
    patch '/orders/:id', to: 'dashboard#update'
  end

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'
end
