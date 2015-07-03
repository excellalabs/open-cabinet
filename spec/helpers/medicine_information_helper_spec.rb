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
end
