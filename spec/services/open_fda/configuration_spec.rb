require 'rails_helper'

describe 'OpenFda::Configuration' do
  let(:instance) { Class.new { extend OpenFda::Configuration } }

  OpenFda::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'returns the default value' do
        expect(instance.options[key]).to equal(OpenFda::Configuration.const_get("DEFAULT_#{key.upcase}"))
      end
    end
  end

  describe '.configure' do
    OpenFda::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "sets the #{key}" do
        instance.configure do |config|
          config.send("#{key}=", key)
          expect(config.send(key)).to equal key
        end
      end
    end
  end
end
