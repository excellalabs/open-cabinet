require 'faraday'

module OpenFda
  class Client
    include OpenFda::Configuration
    MAX_LIMIT = 100

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

    def initialize(opts = {})
      reset
      merged_options = options.merge(opts)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def query_label(search = nil, count = nil, limit = 15, skip = 0)
      query('/drug/label.json', search, count, limit, skip)
    end

    def query_by_med_name(name, limit = 15, skip = 0)
      query('/drug/label.json', "brand_name:#{name} active_ingredient:#{name} generic_name:#{name}", nil, limit, skip)
    end

    def query_all_records_by_time_period(start_time, end_time)
      start_time_s = start_time.strftime('%Y-%m-%d')
      end_time_s = end_time.strftime('%Y-%m-%d')
      include_delay = true
      query_json_for_all_records('/drug/label.json', "effective_time:[#{start_time_s}+TO+#{end_time_s}]", include_delay)
    end

    private

    def query_json_for_all_records(endpoint, search, include_delay = false)
      accumulated_data = empty_results
      skip = 0
      loop do
        sleep 1 if include_delay
        data = query_as_json(endpoint, search, nil, MAX_LIMIT, skip)
        accumulated_data['results'].push(*(data['results']))
        skip += MAX_LIMIT
        break if data['results'].length < OpenFda::Client::MAX_LIMIT
      end
      accumulated_data
    end

    def query_as_json(endpoint, search, count = nil, limit = 15, skip = 0)
      response = query(endpoint, search, count, limit, skip)
      data = empty_results
      data = JSON.parse(response.body) if response.success?
      data['status'] = response.status
      data
    end

    def query(endpoint, search = nil, count = nil, limit = 15, skip = 0)
      connection(search).get do |req|
        req.url endpoint
        req.params[:api_key] = api_key if api_key
        req.params[:count] = prepare_query(count) if count
        req.params[:limit] = limit
        req.params[:skip] = skip
      end
    end

    def prepare_query(words)
      words.strip.squeeze(' ')
    end

    def empty_results
      { 'results' => [] }
    end

    def connection(search)
      Faraday.new(connection_options(search)) do |req|
        req.adapter :net_http
      end
    end

    def connection_options(search)
      search_unescaped = search ? '?search=' + search : ''
      {
        url: endpoint + search_unescaped
      }
    end
  end
end
