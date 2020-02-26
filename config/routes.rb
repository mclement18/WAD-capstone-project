Rails.application.routes.draw do
  root to: 'home#index'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'account', to: 'account#show'
  patch 'account', to: 'account#update'
  get 'account/edit', to: 'account#edit', as: 'edit_account'
  
  namespace :account do
    resources :trips, only: [:index]
  end
  
  resources :users

  resources :trips

  get 'categories/:category', to: 'categories#index', as: 'categories'
end
