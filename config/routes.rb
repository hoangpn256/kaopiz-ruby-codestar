Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  root 'students#index'
  get 'mainpages/about', to: 'main_pages#about'
end
