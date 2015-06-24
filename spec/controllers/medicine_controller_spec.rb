require 'rails_helper'
include AuthHelper

RSpec.describe MedicineController, type: :controller do
  before(:each) do
    http_login
  end

  describe 'GET #autocomplete' do
    it 'returns list of searchable medicines' do
      Rails.cache.clear
      expect(SearchableMedicine).to receive(:find_in_batches).with(hash_including(batch_size: 5000))
        .and_yield([SearchableMedicine.new(name: 'Tylenol'),
                    SearchableMedicine.new(name: 'Ibuprofen')])

      get :autocomplete

      parsed_body = JSON.parse(response.body)
      expect(response).to be_success
      expect(parsed_body.include?('Tylenol')).to be true
      expect(parsed_body.include?('Ibuprofen')).to be true
    end
  end

  describe 'GET #cabinet' do
    before { expect(controller).to receive(:current_user).and_return(User.new(cabinet: Cabinet.new)) }

    it 'responds successfully with an HTTP 200 status code' do
      get :cabinet
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'User session' do
    before do
      @test_cabinet_id = 4
    end

    it 'finds the cabinet if set in the session' do
      session[:cabinet_id] = @test_cabinet_id
      includes_result = double('Cabinet')
      query_result = Cabinet.new
      expect(Cabinet).to receive(:includes).with(:medicines).and_return(includes_result)
      expect(includes_result).to receive(:find_by_id).with(@test_cabinet_id).and_return(query_result)

      get :cabinet

      expect(assigns(:cabinet)).to eq(query_result)
    end

    it 'uses the user cabinet if it exists' do
      user_cabinet = Cabinet.new(id: @test_cabinet_id)
      expect(controller).to receive(:current_user).and_return(User.new(cabinet: user_cabinet))

      get :cabinet

      expect(assigns(:cabinet)).to eq(user_cabinet)
      expect(session[:cabinet_id]).to eq(@test_cabinet_id)
    end

    it 'creates a cabinet for the user if there is not one already' do
      user = User.new
      created_cabinet = Cabinet.new(id: @test_cabinet_id)
      expect(controller).to receive(:current_user).and_return(user)
      expect(Cabinet).to receive(:create!).with(hash_including(user: user)).and_return(created_cabinet)

      get :cabinet

      expect(assigns(:cabinet)).to eq(created_cabinet)
      expect(session[:cabinet_id]).to eq(created_cabinet.id)
    end
  end
end
