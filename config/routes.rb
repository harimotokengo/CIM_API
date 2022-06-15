Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' , defaults: { format: 'json' } do
      post '/login' => 'sessions#create'
      post '/logout' => 'sessions#destroy'
      resources :users, only: [:create, :update]
      resources :offices, only: [:create, :show, :update] do
        
    end
  end
end
