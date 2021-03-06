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
      patch 'update_index_user'
      get 'attendances/list_of_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    collection {post :import}
    resources :attendances, only: :update do
      member do
        get 'overwork_application'
        patch 'update_overwork'
        patch 'attendances_application'
        patch 'edit_attendances_log_reset', as: :log_reset
        get 'confirmation_one_month'
      end
      collection do
        get 'attendances_authentication'
        patch 'update_attendances_authentication'
        get 'overwork_authentication'
        patch 'update_overwork_authentication'
        get 'edit_attendances_authentication'
        patch 'edit_attendances_authentication_update'
        get 'edit_attendances_log'
        
      end
    end
  end
  resources :bases, except: [:show]
end
