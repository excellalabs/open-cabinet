require 'rails_helper'

describe 'SearchableMedicineParser' do
  context 'mocked data' do
    before do
      allow_any_instance_of(SearchableMedicineParser).to receive(:sleep)
      @mock_writer = double('Writer')
      @mock_client = double('FdaClient')
      key = '12345'
      expect(OpenFda::Client).to receive(:new).with(api_key: key) { @mock_client }
      @start_time = Time.now
      @class_under_test = SearchableMedicineParser.new(key, @mock_writer)
    end

    context 'parsing remote label data' do
      it 'sanitizes the label data it finds' do
        json_data = read_support_file('sanitizes_label_data.json')
        expect_client_call(time_iterations(0), json_data)

        create_write_expectation(['Imipramine Hydrochloride', 'Ibuprofen', 'Tylenol'])

        @class_under_test.pull_searchable_medicines(@start_time, time_iterations(1))
      end

      it 'paginates through the data if necessary' do
        first_pass_data = build_json(OpenFda::Client::MAX_LIMIT, 0)
        expect_client_call(time_iterations(0), first_pass_data)
        second_pass_data = build_json(1, OpenFda::Client::MAX_LIMIT)
        expect_client_call(time_iterations(0), second_pass_data, OpenFda::Client::MAX_LIMIT)
        expected_array = []
        (OpenFda::Client::MAX_LIMIT + 1).times do |i|
          expected_array << 'Name' + i.to_s
        end

        create_write_expectation(expected_array)

        @class_under_test.pull_searchable_medicines(@start_time, time_iterations(1))
      end

      it 'iterates through the time periods' do
        first_step_data = build_json(1, 0)
        expect_client_call(time_iterations(0), first_step_data)
        second_step_data = build_json(1, 1)
        expect_client_call(time_iterations(1), second_step_data)

        create_write_expectation(%w(Name0 Name1))

        @class_under_test.pull_searchable_medicines(@start_time, time_iterations(2))
      end
    end

    def build_json(num_times, offset)
      result = { 'results' => [] }
      num_times.times do |i|
        result['results'] << { 'openfda' => { 'generic_name' => ['Name' + (offset + i).to_s] } }
      end
      result.to_json
    end

    def time_iterations(times)
      @start_time + (times * SearchableMedicineParser::TIME_STEP)
    end

    def expect_client_call(time_start, json_data, skip = 0)
      response = double('response')
      expect(response).to receive(:status) { 200 }
      expect(response).to receive(:body) { json_data }
      expect(@mock_client).to receive(:query_by_time_period).with(time_start,
                                                                  time_start + SearchableMedicineParser::TIME_STEP,
                                                                  OpenFda::Client::MAX_LIMIT,
                                                                  skip) { response }
    end
  end

  context 'VCR data' do
    it 'should parse VCR data correctly' do
      @mock_writer = double('Writer')
      allow_any_instance_of(SearchableMedicineParser).to receive(:sleep)
      expected = read_support_file('expected_vcr_data.txt').split("\n")
      create_write_expectation(expected)

      parser = SearchableMedicineParser.new(nil, @mock_writer)
      start_time = Time.new(2009, 2, 21)
      end_time = Time.new(2009, 6, 21)
      VCR.use_cassette 'searchable_medicine_parser/fda_response' do
        parser.pull_searchable_medicines(start_time, end_time)
      end
    end
  end

  def read_support_file(file_name)
    File.read(Rails.root.join('spec', 'data', 'searchable_medicine_parser').to_s + '/' + file_name)
  end

  def create_write_expectation(expected_array)
    expect(@mock_writer).to receive(:write) do |ary|
      expect(ary).to match_array(expected_array)
    end
  end
end
