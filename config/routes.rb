Rails.application.routes.draw do
  get 'categories/show'

  post '/rate' => 'rater#create', :as => 'rate'

  devise_for :users, controllers: {
    omniauth_callbacks: "callbacks",
    registrations: "registrations"
  }
  root "products#index"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"

  resources :users, only: [:show]
  namespace :admin do
    resources :users, only: [:index, :destroy]
    resources :categories do
      resources :products, only: [:index]
    end
    resources :products
    resources :orders
    resources :suggests
  end
  resources :products do
    resources :comments
  end
  get "/cart", to: "cart#index"
  post "/cart/:id", to: "cart#create"
  delete "/cart/:id/delete", to: "cart#destroy"
  patch "/cart", to: "cart#update"
  resources :orders
  resources :categories, only: [:show]
end
