require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  post '/cart', to: 'carts#add_item'
  get '/cart', to: 'carts#show'
  put '/cart/add_item', to: 'carts#update_item'
  delete '/cart/:product_id', to: 'carts#remove_item'
  delete '/cart', to: 'carts#clear'


  root "rails/health#show"
end
