Rails.application.routes.draw do
  root to: 'home#index'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'account', to: 'account#show'
  patch 'account', to: 'account#update'
  delete 'account', to: 'account#destroy'
  get 'account/edit', to: 'account#edit', as: 'edit_account'
  
  namespace :account do
    resources :trips, only: :index
    get 'todolist', to: 'to_dos#dreams'
    get 'travels', to: 'to_dos#travels'
    get 'success', to: 'to_dos#success'
  end
  
  resources :users do
    resources :to_dos, only: [:create, :update, :destroy]
  end

  concern :commentable do
    resources :comments
  end

  patch 'trips/:trip_id/stages', to: 'stages#reorder', as: 'reorder_trip_stages'
  resources :trips do
    resources :stages
    concerns :commentable
  end

  scope 'stages/:stage_id', as: 'stage' do
    concerns :commentable
  end

  get 'categories/:category', to: 'categories#index', as: 'categories'

  scope 'locationselect' do
    get 'regions', to: 'location_select#regions'
    get 'cities', to: 'location_select#cities'
  end

  mount ActionCable.server => '/cable'
end
