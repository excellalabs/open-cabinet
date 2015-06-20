Rails.application.routes.draw do
  devise_for :users
  root 'medicine#index'

  get 'lookup', to: 'medicine#search'
  get 'autocomplete', to: 'medicine#autocomplete'
  get 'cabinet', to: 'medicine#cabinet'

end
