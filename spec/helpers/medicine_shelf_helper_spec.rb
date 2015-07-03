require 'rails_helper'

RSpec.describe MedicineShelfHelper do
  before do
    allow_any_instance_of(Medicine).to receive(:init) { '' }
    allow_any_instance_of(Medicine).to receive(:interaction_names) { [] }
    allow_any_instance_of(Medicine).to receive(:interacts_with) { '' }
    allow_any_instance_of(Medicine).to receive(:interaction_count) { 0 }
  end

  describe 'cabinet shows empty shelves' do
    it 'shows empty shelves with 0 medicines' do
      result = helper.show_shelves(Cabinet.new, nil)

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS)
    end

    it 'shows minimum number of shelves even if there are 2 medications in the shelf' do
      cabinet = Cabinet.new(medicines: [Medicine.new(name: 'med1'), Medicine.new(name: 'med2')])
      result = helper.show_shelves(cabinet, nil)

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS - 1)
    end
  end
end
