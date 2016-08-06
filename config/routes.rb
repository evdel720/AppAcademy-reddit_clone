Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :subs, except: :destroy
  resources :posts do
    resources :comments, only: [:new, :create]
  end

  resource :session, only: [:new, :create, :destroy]
  root to: "subs#index"
end
