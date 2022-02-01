Rails.application.routes.draw do
  get 'attendances/edit'

  get 'sessions/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    'login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'edit_basic_work_info', to: 'users#edit_basic_work_info'

  resources :users do
    member do
      patch 'update_index'
      get 'attendances/list_of_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/attendances_authentication'
      get 'attendances/edit_attendances_authentication'
      get 'attendances/overwork_authentication'
      get 'attendances/attendances_log'
    end
    resources :attendances, only: :update do
      member do
        get 'overwork_application'
        patch 'update_overwork'
      end
    end
  end
  resources :bases, except: [:show]
end
