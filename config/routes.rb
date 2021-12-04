Rails.application.routes.draw do

  resources :users
  get '/users', to: "users#index"
  get 'user/show'
  get 'user/edit'
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
