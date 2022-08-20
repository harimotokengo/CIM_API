Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' , defaults: { format: 'json' } do
      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'
      get '/me' => 'sessions#me'
      resources :users, only: [:create, :update]
      resources :offices, only: [:create, :show, :update] do
        resources :office_users
      end
      resources :user_invites, only: [:new, :create, :show] do
        collection do
          post 'join'
          post 'reg_and_join'
        end
      end
      resources :clients, only: [:index, :create, :show, :update, :destroy ] do
        resources :client_joins, only: [:index, :create, :update, :destroy] do
          collection do
            post 'create_token'
            get 'get_invite_url'
          end
        end
        resources :matters, only: :create do
          collection do
            get 'get_join_users'
          end
        end
        collection do
          get 'conflict_check'
          get 'get_category_parents'
          get 'get_category_children'
          get 'get_join_users'
        end
        member do
          get 'client_matters'
        end
        
      end
      resources :matters, only: [:index, :show, :update, :destroy] do
        resources :charges, only: [:create, :destroy]
        resources :matter_assigns, only: [:create, :destroy]
        resources :matter_joins, only: [:index, :create, :update, :destroy] do
          collection do
            post 'create_token'
            get 'get_invite_url'
          end
        end
        member do
          get 'get_join_users'
        end
        collection do
          get 'tag_auto_complete'
        end
      end
      resources :invite_urls, only: :show
      resources :tasks, only: [:index, :create, :update, :destroy]
      resources :task_templates, only: [:create, :update, :destroy]
      resources :work_stages, only: [:create, :update, :destroy]
      resources :work_logs, only: [:create, :update, :destroy]
      resources :fees, only: [:index, :create, :update, :destroy]
    end
  end
end
