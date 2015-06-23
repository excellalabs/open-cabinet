Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get 'autocomplete', to: 'medicine#autocomplete'
  get 'cabinet', to: 'medicine#cabinet'
  post 'add_to_cabinet', to: 'medicine#add_to_cabinet'
end
