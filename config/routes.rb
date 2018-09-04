Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users, only: [:index, :update]
    resources :categories, only: [:index, :create, :update, :destroy]
    resources :menus
    root "users#index"
  end
end
