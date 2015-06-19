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

    def query(search = nil, count = nil, limit = 15, skip = 0)
      connection.get do |req|
        req.url '/drug/label.json'
        req.params[:api_key] = api_key if api_key
        req.params[:search] = search if search
        req.params[:count] = count if count
        req.params[:limit] = limit
        req.params[:skip] = skip
      end
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
