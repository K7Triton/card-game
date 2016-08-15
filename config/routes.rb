Rails.application.routes.draw do

  root to: 'rooms#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :rooms do
  resources :room_message
end

  get 'rooms/:id/start', to: 'rooms#start_game', as: 'start_game'
end
