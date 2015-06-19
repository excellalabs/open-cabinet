module OpenFda
  module Configuration
    VALID_CONNECTION_KEYS = [:endpoint, :user_agent].freeze
    VALID_OPTIONS_KEYS    = [:api_key, :format].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS

    DEFAULT_ENDPOINT    = 'https://api.fda.gov'
    DEFAULT_USER_AGENT  = 'OpenFDA API Ruby Service'.freeze

    DEFAULT_API_KEY      = nil
    DEFAULT_FORMAT       = :json

    # Build accessor methods for every config options so we can do this, for example:
    #   Awesome.format = :xml
    attr_accessor(*VALID_CONFIG_KEYS)

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def configure
      yield self
    end

    def reset
      self.endpoint   = DEFAULT_ENDPOINT
      self.user_agent = DEFAULT_USER_AGENT

      self.api_key    = DEFAULT_API_KEY
      self.format     = DEFAULT_FORMAT
    end

    def options
      Hash[* VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten]
    end
  end
end
