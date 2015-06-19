require 'rails_helper'

describe 'OpenFda::Client' do
  before do
    @keys = OpenFda::Configuration::VALID_CONFIG_KEYS
  end

  context 'using module configuration' do
    it 'inherits module configuration' do
      api = OpenFda::Client.new
      @keys.each do |key|
        expect(api.respond_to?(key)).to be true
      end
    end

    context 'with class configuration' do
      before do
        @config = {
          api_key: 'ak',
          format: 'of',
          endpoint: 'ep',
          user_agent: 'ua'
        }
      end

      it 'overrides module configuration' do
        api = OpenFda::Client.new(@config)
        @keys.each do |key|
          expect(api.send(key)).to equal @config[key]
        end
      end

      it 'overrides module configuration after init' do
        api = OpenFda::Client.new

        @config.each do |key, value|
          api.send("#{key}=", value)
        end

        @keys.each do |key|
          expect(api.send("#{key}")).to equal @config[key]
        end
      end
    end
  end
end
