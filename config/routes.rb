Rails.application.routes.draw do

  root 'pages#home'
  get 'help' => 'pages#help'
  get 'about' => 'pages#about'

  get 'signup' => 'users#new'
  post 'users' => 'users#create'
  get 'stats' => 'users#show'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'forgot' => 'password_resets#new'
  post 'forgot' => 'password_resets#create'
  get 'reset/:id' => 'password_resets#edit', as: :reset
  patch 'reset/:id' => 'password_resets#update'

  # get 'game/:show_date' => 'games#edit', as: :game
  # patch 'game/:show_date' => 'games#update'
  delete 'delete/:show_date' => 'games#destroy', as: :delete
  get 'game' => 'games#game', as: :game
  # post 'game' => 'games#create'
  get 'json/:show_date' => 'games#json', as: :json
  post 'save' => 'games#save', as: :save
end
