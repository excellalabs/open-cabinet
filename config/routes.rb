Rails.application.routes.draw do
  devise_for :users
  root 'medicine#index'

  get 'lookup', to: 'medicine#search'
  get 'cabinet', to: 'medicine#cabinet'
end
