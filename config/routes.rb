Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :user do
    resources :images, only: [:create, :destroy]
  end

  resources :images do
    member do
      put 'like', to: 'images#upvote_like'
      put 'dislike', to: 'images#downvote_like'
    end
  end

  resources :images do
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'static_pages#home'
  get  'static_pages/help',    to: 'static_pages#help'
  get  'static_pages/about',   to: 'static_pages#about'
  get  'static_pages/contacts', to: 'static_pages#contacts'
  get 'auth/:provider/callback', to: 'sessions#create', as: :create_sesion
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'users/create_remote', to: 'images#create_remote'
  get 'images/share/:id', to: 'images#share'
  get '/static_pages/home', to: 'static_pages#home'
  #put '/user/:id/update', to: 'user#update'
  # api
  # namespace :api do
  #  namespace :v1 do
  #    resources :users do
  #      resources :images,  only: [:create, :destroy]
  #    end
  #    resources :images do
  #      member do
  #        put 'like', to: 'images#upvote'
  #        put 'dislike', to: 'images#downvote'
  #      end
  #      resources :comments
  #    end
  #    resources :comments do
  #      resources :comments
  #    end
  #  end
  # end

  namespace :api do
    namespace :v1 do
      put 'images/like/', to: 'images#upvote_like'
      put 'images/dislike/', to: 'images#downvote_like'
      resources :users, only: [:index, :show]
      resources :images do
        # member do
          # put 'like', to: 'images#upvote'
          # put 'dislike', to: 'images#downvote'
        # end
      end
      delete 'comments', to: 'comments#destroy'
      resources :comments, only: [:index, :create, :show, :update]
    end
  end
end
