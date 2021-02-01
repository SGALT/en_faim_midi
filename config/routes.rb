Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :clients
  resources :menus
  resources :menu_choices do
    member do
      patch 'change'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
