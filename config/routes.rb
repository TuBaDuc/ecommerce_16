Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  namespace :admin do
    get 'orders/index'
  end

  devise_for :users, controllers: {
    omniauth_callbacks: "callbacks",
    registrations: "registrations"
  }
  root "static_pages#home"
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
end
