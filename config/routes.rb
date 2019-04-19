Rails.application.routes.draw do

  root 'pages#home'

  get 'help' => 'pages#help'
  get 'about' => 'pages#about'

  get 'signup' => 'users#new'
  post 'users' => 'users#create'
  get 'stats' => 'users#show'
  get 'sample' => 'users#sample'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'forgot' => 'password_resets#new'
  post 'forgot' => 'password_resets#create'
  get 'reset/:id' => 'password_resets#edit', as: :reset
  patch 'reset/:id' => 'password_resets#update'

  get 'game' => 'games#game', as: :game
  delete 'delete/:game_id' => 'games#destroy', as: :delete

  get 'backup' => 'backups#new'
  post 'restore' => 'backups#restore'

  # Allow only Ajax requests to the following routes:
  constraints(->(req) { req.xhr? }) do
    get 'json/:game_id' => 'games#json', as: :json
    post 'save' => 'games#save', as: :save
    patch 'redate' => 'games#redate', as: :redate
    get 'check/:final_id' => 'games#check', as: :check

    patch 'filters' => 'users#update_user_filters'
  end
end
