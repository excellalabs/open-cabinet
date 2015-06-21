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

    def query_by_time_period(start_time, end_time, limit = 15, skip = 0)
      start_time_s = start_time.strftime('%Y-%m-%d')
      end_time_s = end_time.strftime('%Y-%m-%d')
      query('/drug/label.json', "effective_time:[#{start_time_s}+TO+#{end_time_s}]", nil, limit, skip)
    end

    private

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
