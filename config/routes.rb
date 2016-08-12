Rails.application.routes.draw do

  root to: 'rooms#index'

  devise_for :users

  resources :rooms

  get 'rooms/:id/start', to: 'rooms#start_game', as: 'start_game'
end
