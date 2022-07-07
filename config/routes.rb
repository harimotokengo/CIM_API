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
        collection do
          get 'conflict_check'
        end
        resources :matters, only: [:create, :show, :update, :destroy]
      end
    end
  end
end
