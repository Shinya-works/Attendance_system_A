Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get 'login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      patch 'update_index'
      get 'attendances/list_of_employees'
    end
  end
  resources :bases, except: [:show]

end
