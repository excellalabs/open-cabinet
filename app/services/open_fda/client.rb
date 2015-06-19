require 'faraday'

module OpenFda
  class Client
    include OpenFda::Configuration

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

    private

    def query(endpoint, search = nil, count = nil, limit = 15, skip = 0)
      connection.get do |req|
        req.url endpoint
        req.params[:api_key] = api_key if api_key
        req.params[:search] = prepare_query(search) if search
        req.params[:count] = prepare_query(count) if count
        req.params[:limit] = limit
        req.params[:skip] = skip
      end
    end

    def prepare_query(words)
      words.strip.squeeze(' ')
    end

    def connection
      @conn ||= Faraday.new(connection_options) do |req|
        req.adapter :net_http
      end
    end

    def connection_options
      {
        url: endpoint
      }
    end
  end
end
