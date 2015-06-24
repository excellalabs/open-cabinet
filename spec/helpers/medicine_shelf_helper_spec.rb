require 'rails_helper'

RSpec.describe MedicineShelfHelper do
  before do
    med1 = Medicine.create!(name: 'test1 drug')
    @cabinet = Cabinet.new(medicines: [med1, Medicine.new])
  end

  describe 'show shelves' do
    it 'renders proper html' do
      result = helper.show_shelves(@cabinet)
      expect(result).to include(helper.send(:medicine_html, Medicine.first))
      expect(result).to be_a(String)
    end
  end
end
