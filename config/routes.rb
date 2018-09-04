Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :users, only: [:index, :update]
    resources :categories, only: [:index, :create, :update, :destroy]
    resources :menus
    root "users#index"
  end

  resources :purchases do
    member do
      get  :edit_order
      post :update_order
    end
  end
  resources :orders, only: [:create, :update, :destroy]
  root "purchases#index"
end
