require 'rails_helper'

RSpec.describe MedicineInformationHelper do
  describe 'build_information_section' do
    it 'draws the section content correctly' do
      result = helper.build_information_section('Name', 'test_id', 'text text')

      expect(result).to have_selector('section h3', text: 'Name')
      expect(result).to have_selector('section div#test_id p', text: 'text text')
    end

    it 'should have default text if none is provided' do
      result = helper.build_information_section('Name', 'test_id', nil)

      expect(result).to have_selector('section div#test_id p', text: 'No information was found for this section on this medicine.')
    end
  end

  describe 'highlight_interactions' do
    before do
      allow_any_instance_of(Medicine).to receive(:init) { '' }
    end

    it 'returns default text if blank is passed in' do
      result = highlight_interactions('', Medicine.new)

      expect(result).to eq('No interaction label data is present')
    end

    it 'inserts colorized spans in interaction text' do
      text = 'test thing1 test thing2'

      result = highlight_interactions(text, Medicine.new(name: 'thing1', active_ingredient: 'thing2'))

      expect(result).to eq(expected_highlighted_text)
    end
  end

  def expected_highlighted_text
    'test <span class="neon highlight scroll-to">thing1</span> test <span class="neon highlight scroll-to">thing2</span>'
  end
end
