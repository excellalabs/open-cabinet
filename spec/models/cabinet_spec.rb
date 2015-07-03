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

  describe 'find_medicine_by_name' do
    it 'finds the medicine by name' do
      medicine = Medicine.new
      medicine.name = 'test'
      cabinet = Cabinet.new(medicines: [medicine, Medicine.new])

      result = cabinet.find_medicine_by_name('test')

      expect(result).to eq(medicine)
    end
  end

  describe 'identify_primary' do
    before do
      @med1 = Medicine.new(name: 'med1')
      @med2 = Medicine.new(name: 'med2')
      @identify_primary_cabinet = Cabinet.new(medicines: [@med1, @med2])
      expect(@identify_primary_cabinet).to receive(:rebuild_cabinet)
    end

    it 'returns the medicine by name and rebuilds the cabinet' do
      result = @identify_primary_cabinet.identify_primary('med2')

      expect(result).to eq(@med2)
    end

    it 'returns the first medicine if the name is not found' do
      result = @identify_primary_cabinet.identify_primary('med3')

      expect(result).to eq(@med1)
    end
  end

  describe 'destroy_medicine' do
    before do
      @med1 = Medicine.new(name: 'med1')
      @med2 = Medicine.new(name: 'med2')
      @med3 = Medicine.new(name: 'med3')
      @destroy_medicine_cabinet = Cabinet.new(medicines: [@med1, @med2, @med3])
      @destroy_medicine_cabinet.save!
    end

    it 'deletes medicines in the provided hash' do
      delete_hash = { 'med1' => 'med1', 'med2' => 'med2' }

      @destroy_medicine_cabinet.destroy_medicine(delete_hash)

      @destroy_medicine_cabinet.reload
      expect(@destroy_medicine_cabinet.medicines.length).to eq(1)
      expect(@destroy_medicine_cabinet.medicines.first).to eq(@med3)
    end

    it 'deletes the medicine by name' do
      @destroy_medicine_cabinet.destroy_medicine('med1')

      @destroy_medicine_cabinet.reload
      expect(@destroy_medicine_cabinet.medicines.include?(@med1)).to be false
    end
  end

  describe 'rebuild_cabinet' do
    before do
      @med1 = Medicine.new(name: 'med1', set_id: 'med1')
      @med2 = Medicine.new(name: 'med2', set_id: 'med2')
      @rebuild_cabinet = Cabinet.new(medicines: [@med1, @med2])
    end

    it 'sets interactions for each medicine' do
      expect(Medicine).to receive(:set_interactions).with(@med1, @med2)
      expect(Medicine).to receive(:set_interactions).with(@med2, @med1)

      @rebuild_cabinet.rebuild_cabinet
    end
  end
end
