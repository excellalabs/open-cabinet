module OpenFda
  class SearchableMedicines < OpenFda::Client
    include OpenFda::Helpers::DataParser
    # query for labels every 60 days
    TIME_STEP = 60 * 60 * 24 * 60

    def initialize(key, writer)
      super(api_key: key)
      @output_writer = writer
    end

    def pull_searchable_medicines(start_time, finish_time)
      Rails.logger.info 'Beginning import...'
      names = pull_for_time_period(start_time, finish_time)
      @output_writer.write(names)
    end

    private

    def pull_for_time_period(start_time, finish_time)
      names = {}
      while start_time < finish_time
        end_time = start_time + TIME_STEP
        data = parse_for_time_step(start_time, end_time)
        names.merge!(tabulate_medicine_names(data))
        start_time = end_time
      end
      names
    end

    def parse_for_time_step(start_time, end_time)
      result = query_all_records_by_time_period(start_time, end_time)
      Rails.logger.info 'Found ' + result['results'].length.to_s + ' records for ' + start_time.strftime('%m/%d/%Y')
      result
    end

    def tabulate_medicine_names(data)
      return {} if data.keys.length == 0
      begin
        return parse_names(data)
      rescue => ex
        Rails.logger.error data.inspect
        raise ex
      end
    end

    def parse_names(data)
      tabulation = {}
      data['results'].each do |result|
        tabulate(tabulation, result, 'generic_name')
        tabulate(tabulation, result, 'brand_name')
      end
      tabulation
    end
  end
end
