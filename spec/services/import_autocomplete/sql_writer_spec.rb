require 'rails_helper'

describe 'ImportAutocomplete::SqlWriter' do
  before do
    SearchableMedicine.create(name: 'test')
  end

  context 'saving data' do
    xit 'deletes the data and inserts new data' do
      data = %w(thing1 thing2)
      sql_writer = ImportAutocomplete::SqlWriter.new

      sql_writer.write(data)

      saved_data = SearchableMedicine.all
      data.each do |x|
        expect(saved_data.map(&:name).include?(x)).to be true
      end
    end
  end
end
