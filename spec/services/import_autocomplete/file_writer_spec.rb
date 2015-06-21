require 'rails_helper'

describe 'ImportAutocomplete::FileWriter' do
  before do
    @test_file = Rails.root.join('spec', 'data', 'file_writer').to_s + '/test.txt'
    File.delete(@test_file) if File.exist?(@test_file)
  end

  context 'writing files' do
    it 'writes a file with the data' do
      data = %w(thing1 thing2)
      file_writer = ImportAutocomplete::FileWriter.new(@test_file)

      file_writer.write(data)

      expect("thing1\nthing2").to eq(File.read(@test_file))
    end
  end
end
