Rails.application.routes.draw do

  get 'follows/create'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'users/show'
  get 'users/index'
  get 'profiles/index'
  get 'profiles/show'
  get 'profiles/create'
  get 'profiles/new'
  get 'profiles/edit'
  get 'profiles/update'
  get 'profiles/destroy'
   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get 'auth/:provider/callback', to: 'sessions#googleAuth'
    get 'auth/failure', to: redirect('/')

   devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    # root to: 'users/sessions#new'
    get 'sign_in', to: 'users/sessions#new'
    get '/users/sign_out', to: 'users/sessions#destroy'
    get 'users/edit' => 'users/registrations#edit'
    get 'users/sign_up' => 'users/registrations#new'

  end

    resources :users do
      member do
        get :following, :followers
        post 'follow', to: "users#follow"
        post 'unfollow', to: "users#unfollow"
      end
    end


  resources :profiles
  
  resources :articles do
    collection do 
      get "tag_articles", to: "articles#tag_articles"
      get "own_articles", to: "articles#own_articles"
      get "trending_articles", to: "articles#trending_articles"
    end

    member do
      patch "upvote", to: "articles#upvote"
      patch "downvote", to: "articles#downvote"
   end
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  get 'search', to: "application#search"
  root to: 'articles#index'


end
