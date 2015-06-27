Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: "devise/registrations#new"
  end

  get 'autocomplete', to: 'medicine#autocomplete'
  get 'cabinet', to: 'medicine#cabinet'
  post 'add_to_cabinet', to: 'medicine#add_to_cabinet'
  delete 'destroy', to: 'medicine#destroy', as: 'destroy_medicine'
  get 'information', to: 'medicine#information'
  post 'update_primary_medicine', to: 'medicine#update_primary_medicine'

  mount Flip::Engine => '/features'
end
