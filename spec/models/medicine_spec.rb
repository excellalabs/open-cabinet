require 'rails_helper'

RSpec.describe Medicine, type: :model do
  it 'can be created with the proper attributes' do
    Medicine.create!(set_id: '123456789', name: 'Advil', active_ingredient: 'ibuprofen')

    expect(Medicine.first.set_id).to eq('123456789')
    expect(Medicine.first.name).to eq('Advil')
    expect(Medicine.first.active_ingredient).to eq('ibuprofen')
  end

  it 'will not be created and throw an error if values are nil' do
    expect { Medicine.create!(set_id: nil, name: nil, active_ingredient: nil) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  describe 'fetch_information' do
    it 'should set the result of several OpenFda Client queries to attribute accessors' do
      allow_any_instance_of(OpenFda::Client).to receive(:query_by_set_id) { '' }
      allow_any_instance_of(Medicine).to receive(:fetch_array_from_response) { 'Sample text' }

      med = Medicine.new
      med.fetch_information
      %w(warnings dosage_and_administration indications_and_usage).each do |field|
        expect(med.send(field)).to eq('Sample text')
      end
    end
  end

  describe 'fetch_interactions_text' do
    it 'should set the result of an OpenFda query to interactions_text' do
      allow_any_instance_of(OpenFda::Client).to receive(:query_for_interactions) { '' }
      allow_any_instance_of(Medicine).to receive(:fetch_array_from_response) { 'Interactions text' }

      med = Medicine.new
      med.fetch_interactions_text
      expect(med.interactions_text).to eq('Interactions text')
    end
  end
end
