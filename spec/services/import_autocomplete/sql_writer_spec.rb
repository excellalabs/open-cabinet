require 'rails_helper'

describe 'ImportAutocomplete::SqlWriter' do
  before do
    SearchableMedicine.create(name: 'test', set_id: '1239df0-adsf-121')
  end

  context 'saving data' do
    it 'deletes the data and inserts new data' do
      data = { 'thing1' => { set_id: '12310-asdf-12da' }, 'thing2' => { set_id: '12310-a-12da' } }
      sql_writer = ImportAutocomplete::SqlWriter.new

      sql_writer.write(data)

      saved_data = SearchableMedicine.all
      data.each do |x|
        expect(saved_data.map(&:name).include?(x[0])).to be_truthy
        expect(saved_data.map(&:set_id).include?(x[1][:set_id])).to be_truthy
      end
    end
  end
end
