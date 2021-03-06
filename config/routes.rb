# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get 'help', to: "static_pages#help"
  get 'about', to: "static_pages#about"
  get 'contact', to: "static_pages#contact"

  get 'signup', to: 'users#new'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  resources :users, except: %i[new]
  resources :posts
  resources :account_activations, only: %i[edit]
  resources :password_resets, only: %i[new create edit update]

  default_url_options :host => "localhost:3000"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
