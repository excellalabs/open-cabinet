require 'rails_helper'

RSpec.describe MedicineShelfHelper do
  before do
    allow_any_instance_of(Medicine).to receive(:init) { '' }
  end

  describe 'cabinet shows empty shelves' do
    it 'shows empty shelves with 0 medicines' do
      result = helper.show_shelves(Cabinet.new, nil, {})

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS)
    end

    it 'shows minimum number of shelves even if there are 2 medications in the shelf' do
      primary_medicine = Medicine.new(name: 'med1')
      cabinet = Cabinet.new(medicines: [primary_medicine, Medicine.new(name: 'med2')])
      result = helper.show_shelves(cabinet, primary_medicine, {})

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS - 1)
    end
  end
end
