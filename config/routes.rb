Rails.application.routes.draw do

  resources :coupons
  get 'home/index'
  devise_for :users
  resources :items do
  	resource :subscriptions
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "home#index"

end
