require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  
  get 'prices/index'
  resources :networks
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'wallets#index'

  resources :wallets, only: %i[index show destroy] do
    delete :bulk_delete, on: :collection
  end
  resources :trashes
  resources :histories, only: %i[index show]
  resources :prices, only: %i[index]
  resources :tokens, only: %i[] do
    member do
      delete :trash
    end
  end

  get 'import', to: 'import#show'
  post 'import', to: 'import#create'
  get 'refresh', to: 'refreshes#index'
  get 'winners', to: 'winners#show'
  post 'winners', to: 'winners#create'
end
