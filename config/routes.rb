Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :user do
    resources :images,  only: [:create, :destroy]
  end

  resources :images do
    member do
      put 'like', to: 'images#upvote'
      put 'dislike', to: 'images#downvote'  
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
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
end
