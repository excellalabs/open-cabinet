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

  describe 'destroy' do
    it 'deletes the medicine' do
      med_name = 'Tylenol'
      cabinet = create_cabinet_with_one_medicine(med_name)

      delete :destroy, medicine: cabinet.medicines.first.name

      cabinet.reload
      expect(0).to eq cabinet.medicines.length
      expect(assigns(:cabinet)).to eq(cabinet)
    end
  end

  describe 'User session' do
    before do
      @test_cabinet_id = 4
    end

    it 'finds the cabinet if set in the session' do
      cabinet = create_cabinet_with_one_medicine 'test'

      get :cabinet

      expect(assigns(:cabinet)).to eq(cabinet)
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

  def create_cabinet_with_one_medicine(medicine_name = nil)
    cabinet = Cabinet.create
    session[:cabinet_id] = cabinet.id
    Medicine.create(cabinet: cabinet, name: medicine_name)
    cabinet
  end
end
