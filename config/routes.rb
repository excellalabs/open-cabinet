Rails.application.routes.draw do
  devise_for :users
  root 'medicine#index'

  get 'lookup', to: 'medicine#search'
  get 'autocomplete', to: 'medicine#autocomplete'
  get 'cabinet', to: 'medicine#cabinet'
  post 'add_to_cabinet', to: 'medicine#add_to_cabinet'
end
