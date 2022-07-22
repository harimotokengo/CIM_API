Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' , defaults: { format: 'json' } do
      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'
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
          get 'get_category_childeren'
          get 'get_join_users'
        end
        member do
          get 'get_matters'
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
      end
      resources :invite_urls, only: :show
    end
  end
end
