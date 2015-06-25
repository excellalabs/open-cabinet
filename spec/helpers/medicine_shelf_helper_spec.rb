require 'rails_helper'

RSpec.describe MedicineShelfHelper do
  describe 'cabinet shows empty shelves' do
    it 'shows empty shelves with 0 medicines' do
      result = helper.show_shelves(Cabinet.new)

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS)
    end

    it 'shows minimum number of shelves even if there are 2 medications in the shelf' do
      result = helper.show_shelves(Cabinet.new(medicines: [Medicine.new(name: 'med1'), Medicine.new(name: 'med2')]))

      expect(result).to have_selector('div.empty-shelf', count: MedicineShelfHelper::MIN_ROWS - 1)
    end
  end

  describe 'show shelves' do
    before do
      med1 = Medicine.create!(name: 'test1 drug')
      @cabinet = Cabinet.new(medicines: [med1, Medicine.new])
    end

    it 'renders proper html' do
      result = helper.show_shelves(@cabinet)
      expect(result).to include(helper.send(:medicine_html, Medicine.first))
      expect(result).to be_a(String)
    end
  end
end
