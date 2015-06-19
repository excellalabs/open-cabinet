require 'faraday'

module OpenFda
  class Client
    include OpenFda::Configuration

    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(opts={})
      merged_options = options.merge(opts)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def find_by(field, term)
      connection.get do |req|
        req.url '/drug/label.json'
        req.params[:api_key] = api_key if api_key
        req.params[:search] = "#{field}:#{term}"
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
