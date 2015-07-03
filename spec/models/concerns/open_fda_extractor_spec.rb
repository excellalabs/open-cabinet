require 'rails_helper'

describe 'OpenFdaExtractor' do
  let(:instance) { Class.new { extend OpenFdaExtractor } }

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
      expect(instance.fetch_string_from_response(@response, 'test_key')).to eq('My Test Value.')
    end

    it 'should return nil if the response was not successful' do
      allow(@response).to receive(:success?) { false }
      expect(instance.fetch_string_from_response(@response, 'test_key')).to eq(nil)
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
      expect(instance.fetch_array_from_response(@response, 'test_key')).to eq('My Test Value.')
    end

    it 'should return nil if the response was not successful' do
      allow(@response).to receive(:success?) { false }
      expect(instance.fetch_array_from_response(@response, 'test_key')).to eq(nil)
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
      expect(instance.fetch_array_from_response(response, 'test_key')).to eq(nil)
    end
  end
end
