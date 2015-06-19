Rails.application.routes.draw do
  devise_for :users
  root 'drug_search#index'

  get 'secure', to: 'drug_search#secure'
end
