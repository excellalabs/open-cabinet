Rails.application.routes.draw do
  devise_for :users
  root 'hello#index'

  get 'secure', to: 'hello#secure'
end
