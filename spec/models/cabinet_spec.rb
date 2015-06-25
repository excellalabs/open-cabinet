require 'rails_helper'

RSpec.describe Cabinet, type: :model do
  it 'can contain medicines' do
    cabinet = Cabinet.new(medicines: [Medicine.new, Medicine.new])

    expect(cabinet.medicines.length).to eq(2)
  end

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
