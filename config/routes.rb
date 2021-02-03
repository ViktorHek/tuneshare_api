Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { omniauth_callbacks: 'api/omniauth_callbacks' }

  namespace :api do
    resources :posts, only: %i[index create destroy] do
      resources :comments, only: %i[create index]
      resources :likes, only: [:create]
    end
    resources :tracks, only: [:index]
    resources :users, only: [:show]
    get 'omniauth_callbacks/spotify'
  end
end
