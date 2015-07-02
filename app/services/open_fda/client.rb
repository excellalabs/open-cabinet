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

    def query_all_records_by_time_period(start_time, end_time)
      start_time_s, end_time_s, include_delay = start_time.strftime('%Y-%m-%d'), end_time.strftime('%Y-%m-%d'), true
      query_json_for_all_records('/drug/label.json', "effective_time:[#{start_time_s}+TO+#{end_time_s}]", include_delay)
    end

    def query_for_interactions(medicine_query)
      if multi_request?(medicine_query)
        fda_query = [*(medicine_query.map { |medicine| "set_id:#{medicine.set_id}+AND+_exists_:drug_interactions" })]
      else
        fda_query = "set_id:#{medicine_query.set_id}+AND+_exists_:drug_interactions"
      end
      query('/drug/label.json', fda_query, nil, 100, 0)
    end

    def query_by_set_id(set_id)
      query('/drug/label.json', "set_id:#{set_id}")
    end

    private

    def query_json_for_all_records(api_endpoint, search, include_delay = false)
      accumulated_data, skip = empty_results, 0
      loop do
        sleep 1 if include_delay
        response = query(api_endpoint, search, nil, 100, skip)
        data = response.success? ? JSON.parse(response.body) : empty_results
        accumulated_data['results'].push(*(data['results']))
        skip += MAX_LIMIT
        break if data['results'].length < MAX_LIMIT
      end
      accumulated_data
    end

    def query(api_endpoint, search = nil, count = nil, limit = 15, skip = 0)
      Typhoeus::Config.cache, hydra = OpenFda::Cache::RequestCache.new, Typhoeus::Hydra.new
      is_multi = multi_request?(search)
      reqs = create_request_queue(api_endpoint, search, count, limit, skip)
      reqs.each { |req| hydra.queue(req) }
      hydra.run
      get_responses(reqs, is_multi)
    end

    def multi_request?(search)
      search ? search.is_a?(Array) : false
    end

    def get_responses(reqs, is_multi)
      return reqs.first.response unless is_multi
      reqs.map(&:response)
    end

    def create_request_queue(api_endpoint, search, count, limit, skip)
      reqs = []
      if multi_request?(search)
        search.each { |searc_req| reqs << create_request(api_endpoint, searc_req, nil, 100, 0) }
      else
        reqs << create_request(api_endpoint, search, count, limit, skip)
      end
      reqs
    end

    def create_request(api_endpoint, search, count, limit, skip)
      params_hash = { limit: limit, skip: skip }
      params_hash[:api_key] = api_key if api_key
      params_hash[:count] = prepare_query(count) if count
      Typhoeus::Request.new(connection_options(api_endpoint, search), params: params_hash)
    end

    def prepare_query(words)
      words.strip.squeeze(' ')
    end

    def empty_results
      { 'results' => [] }
    end

    def connection_options(api_endpoint, search)
      search_unescaped = search ? '?search=' + search : ''
      endpoint + api_endpoint + search_unescaped
    end
  end
end
