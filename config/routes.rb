Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: "devise/registrations#new"
  end

  get 'autocomplete', to: 'medicine#autocomplete'
  get 'cabinet', to: 'medicine#cabinet'
  post 'add_to_cabinet', to: 'medicine#add_to_cabinet'
  delete 'destroy', to: 'medicine#destroy', as: 'destroy_medicine'
  post 'information', to: 'medicine#query_for_information'
  get 'refresh_shelves', to: 'medicine#refresh_shelves'

  mount Flip::Engine => '/features'
end
