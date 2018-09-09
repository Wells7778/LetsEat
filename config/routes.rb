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
      get  :show_orders
      post :close
    end
    collection do
      get  :my
    end
  end
  resources :orders, only: [:index, :create, :update, :destroy] do
    resources :payments, except: [:index, :edit, :update, :destroy]
  end
  root "purchases#index"
end
