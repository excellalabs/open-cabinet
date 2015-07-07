require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def index
      after_sign_in_path_for(User.new)

      render nothing: true
    end
  end

  it 'clears the session cabinet_id' do
    session[:cabinet_id] = 4

    get :index

    expect(session[:cabinet_id]).to be nil
  end
end
