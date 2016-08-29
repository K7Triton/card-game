Rails.application.routes.draw do

  root to: 'rooms#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  mount ActionCable.server => '/cable'
  resources :rooms do
    resources :room_messages
  end


  get 'rooms/:id/start', to: 'rooms#start_game', as: 'start_game'
  get 'rooms/:id/move/:card', to: 'rooms#move'
  get 'rooms/:id/get_card', to: 'rooms#get_card'
  #get 'rooms/:id/start/', to: 'room_message#new', as: 'create_message'
  #post 'rooms/:id/start/', to: 'room_message#create', as: 'create_message'
end
