Rails.application.routes.draw do

  root to: 'rooms#index'

  devise_for :users

  resources :rooms

  get '/start', to: 'rooms#start_game'
end
