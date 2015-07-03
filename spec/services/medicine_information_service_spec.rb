require 'rails_helper'

RSpec.describe MedicineInformationService do
  before do
    allow_any_instance_of(Medicine).to receive(:init) { '' }
  end

  describe 'interactions_text_key' do
    it 'should return the proper symbol' do
      expect(MedicineInformationService.interactions_text_key).to eq(:interaction_text)
    end
  end

  describe 'fetch_information' do
    before do
      allow(Medicine).to receive(:find_by_name) { Medicine.new(name: 'Tylenol', set_id: '1234') }
      allow(MedicineInformationService).to receive(:fetch_array_from_response) { '' }
      allow(MedicineInformationService).to receive(:build_interactions) { '' }
      allow(MedicineInformationService).to receive(:build_bi_directional_interactions) { '' }
      allow_any_instance_of(OpenFda::Client).to receive(:query_by_set_id) { '' }
      allow_any_instance_of(OpenFda::Client).to receive(:query_for_interactions) { '' }
    end

    it 'creates a response hash with all appropriate keys' do
      response = MedicineInformationService.fetch_information('Tylenol', Cabinet.new)

      %i(primary interactions_text indications_and_usage dosage_and_administration warnings interactions all_interactions).each do |key|
        expect(response.keys).to include(key)
      end
      expect(response[:primary]).to eq('Tylenol')
    end
  end

  describe 'find cabinet interactions' do
    before do
      @client = double('client')
      @cabinet = double('cabinet')
      allow(@cabinet).to receive(:medicines) {
        [Medicine.new(name: 'Tylenol', set_id: '1234', active_ingredient: ''),
         Medicine.new(name: 'Advil', set_id: '5678', active_ingredient: 'Ibuprofen')]
      }
      responses = [double('response'), double('response')]
      allow(@client).to receive(:query_for_interactions) { responses }
      responses.each { |double| allow(double).to receive(:success?) { true } }
      allow(MedicineInformationService).to receive(:fetch_string_from_response) { '1234' }
      allow(MedicineInformationService).to receive(:fetch_array_from_response) { 'tylenol advil ibuprofen' }
      allow(MedicineInformationService).to receive(:build_interactions) { { Tylenol: ['Tylenol'] } }
    end

    it 'should return an interactions hash where the value has an interaction hash and the interaction text' do
      all_interactions = MedicineInformationService.find_cabinet_interactions(@cabinet, @client)

      expect(all_interactions.keys.count).to eq(1)
      %i(Tylenol interaction_text).each do |key|
        expect(all_interactions[:Tylenol].keys).to include(key)
      end
      expect(all_interactions[:Tylenol][:interaction_text]).to eq('tylenol advil ibuprofen')
    end
  end

  describe 'build bi-directional interactions' do
    before do
      allow(MedicineInformationService).to receive(:find_cabinet_interactions) { { Tylenol: { Tylenol: ['Tylenol'], Advil: %w(Advil Ibuprofen) } } }
    end

    it 'should return hash with two keys where the values of the first contain the second' do
      result = MedicineInformationService.build_bi_directional_interactions(double)

      expect(result.keys.count).to eq(2)
      %i(Advil Tylenol).each do |key|
        expect(result.keys).to include(key)
      end
      expect(result[:Tylenol].keys.count).to eq(2)
      expect(result[:Advil].keys.count).to eq(1)
    end
  end

  describe 'build interactions' do
    before do
      @medicines = [Medicine.new(name: 'Tylenol', set_id: '1234', active_ingredient: ''),
                    Medicine.new(name: 'Advil', set_id: '5678', active_ingredient: 'Ibuprofen')]
    end

    it 'should return a hash with two entries if the keywords are in the interaction text and set ids dont match' do
      data = MedicineInformationService.build_interactions('0000', @medicines, 'tylenol advil ibuprofen')
      expect(data.keys.count).to eq(2)
    end

    it 'should return a hash with one entry if the set id of a medicine is the same as the primary' do
      data = MedicineInformationService.build_interactions('1234', @medicines, 'tylenol advil ibuprofen')
      expect(data.keys.count).to eq(1)
    end

    it 'should return a hash with zero entries if the keywords are not in the interaction text and set ids dont match' do
      data = MedicineInformationService.build_interactions('0000', @medicines, 'claritin warfarin caffeine')
      expect(data.keys.count).to eq(0)
    end

    it 'should return a hash with two entries where the first has an array with one entry if active ingredient and name are identical' do
      @medicines[0].active_ingredient = 'Tylenol'
      data = MedicineInformationService.build_interactions('0000', @medicines, 'tylenol advil ibuprofen')
      expect(data.keys.count).to eq(2)
      expect(data[:Tylenol].length).to eq(1)
    end
  end

  describe 'fetch string from response' do
    before do
      body = {
        results: [
          { test_key: 'My Test Value.' }
        ]
      }.to_json
      @response = double('response')
      allow(@response).to receive(:body) { body }
    end

    it 'should get the field value from the response body if the response was successful' do
      allow(@response).to receive(:success?) { true }
      expect(MedicineInformationService.fetch_string_from_response(@response, 'test_key')).to eq('My Test Value.')
    end

    it 'should return nil if the response was not successful' do
      allow(@response).to receive(:success?) { false }
      expect(MedicineInformationService.fetch_string_from_response(@response, 'test_key')).to eq(nil)
    end
  end

  describe 'fetch array from response' do
    before do
      body = {
        results: [
          { test_key: ['My Test Value.'] }
        ]
      }.to_json
      @response = double('response')
      allow(@response).to receive(:body) { body }
    end

    it 'should get the array from the response body if the response was successful' do
      allow(@response).to receive(:success?) { true }
      expect(MedicineInformationService.fetch_array_from_response(@response, 'test_key')).to eq('My Test Value.')
    end

    it 'should return nil if the response was not successful' do
      allow(@response).to receive(:success?) { false }
      expect(MedicineInformationService.fetch_array_from_response(@response, 'test_key')).to eq(nil)
    end

    it 'should return gracefully if the value is not an array and the response was successful successful' do
      body = {
        results: [
          { test_key: nil }
        ]
      }.to_json
      response = double('response')
      allow(response).to receive(:body) { body }
      allow(response).to receive(:success?) { true }
      expect(MedicineInformationService.fetch_array_from_response(response, 'test_key')).to eq(nil)
    end
  end
end
