Rails.application.routes.draw do
  devise_for :users
  root 'drug_search#index'

  get 'search', to: 'drug_search#search'
end
