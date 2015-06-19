Rails.application.routes.draw do
  devise_for :users
  root 'medicine#index'

  get 'lookup', to: 'medicine#search'
  get 'search', to: 'drug_search#search'
end
