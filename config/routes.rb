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
  
  resources :users

  resources :trips
end
