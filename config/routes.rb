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
  delete 'delete/:show_date' => 'games#destroy', as: :delete

  # Allow only Ajax requests to the following routes:
  constraints(->(req) { req.xhr? }) do
    get 'json/:show_date' => 'games#json', as: :json
    post 'save' => 'games#save', as: :save
    patch 'redate' => 'games#redate', as: :redate
    get 'check/:final_id' => 'games#check', as: :check

    get 'stats/topics' => 'users#topics', as: :topics
    get 'sample/topics' => 'users#sample_topics'

    get 'stats/by-row' => 'users#by_row', as: :by_row
    get 'sample/by-row' => 'users#sample_by_row'

    patch 'types' => 'users#types'
  end
end
