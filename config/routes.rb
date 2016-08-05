Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  resources :subs, except: :destroy do
    resources :posts, only: [:new, :create]
  end
  resources :posts, except: [:index, :new, :create]

  resource :session, only: [:new, :create, :destroy]
end
