require 'rails_helper'

RSpec.describe Cabinet, type: :model do
  before do
    allow_any_instance_of(Medicine).to receive(:init) { '' }
  end

  it 'can contain medicines' do
    cabinet = Cabinet.new(medicines: [Medicine.new, Medicine.new])

    expect(cabinet.medicines.length).to eq(2)
  end

  describe 'add_to_cabinet' do
    it 'can add a new medicine' do
      cabinet = Cabinet.create!
      med = SearchableMedicine.new(set_id: '1234', name: 'Advil')
      cabinet.add_to_cabinet(med)
      expect(cabinet.medicines.length).to eq(1)
      expect(cabinet.medicines[0].name).to eq('Advil')
    end

    it 'does not add duplicate medicines based on set_id' do
      cabinet = Cabinet.create!(medicines: [Medicine.create!(set_id: '1234', name: 'Advil')])
      med = SearchableMedicine.new(set_id: '1234', name: 'Advil')
      cabinet.add_to_cabinet(med)
      expect(cabinet.medicines.length).to eq(1)
    end
  end

  describe 'num_interactions_for_primary' do
    it 'should return the number of medicines that interact with the primary' do
      cabinet = Cabinet.new(medicines: [Medicine.new(is_interacted_with: true), Medicine.new(is_interacted_with: true)])
      expect(cabinet.num_interactions_for_primary).to eq(2)
    end
  end
end
