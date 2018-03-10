Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  #resources :user 
  #resources :images,          only: [:create, :destroy]
  resources :user do
    resources :images,  only: [:create, :destroy]
  end

  resources :images do
    member do
      put "like", to: "images#upvote"
      put "dislike", to: "images#downvote"      
    end
  end

  resources :images do
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contacts', to: 'static_pages#contacts'
  #get 'static_pages/home',    to: 'static_pages#home'  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
end
