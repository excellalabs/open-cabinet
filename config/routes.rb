Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    root to: 'devise/registrations#new'
  end

  resource 'medicine', path: '', controller: 'medicine', only: [] do
    get 'autocomplete'
    get 'cabinet'
    get 'information'
    get 'medicine_information'
    get 'about'
    post 'add_to_cabinet'
    post 'update_primary_medicine'
    delete 'destroy'
    get 'style_guide'
  end

  mount Flip::Engine => '/features'
end
