require 'rails_helper'
include AuthHelper

RSpec.describe MedicineController, type: :controller do
  before(:each) do
    http_login
  end

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end
end
