# You should edit this file with the browsers you wish to use
# For options, check out http://saucelabs.com/docs/platforms
require 'sauce'
require 'sauce/cucumber'
require 'sauce/capybara'

Sauce.config do |config|
  # config[:application_host] = "http://#{ENV['STACK_URL']}"
  config[:name] = 'OpenCabinet Browser Tests'
  config[:start_tunnel] = false
  config[:start_local_application] = true
  config['tunnel-identifier'] = ENV['TRAVIS_JOB_NUMBER']
  config[:browsers] = [
    ['Windows 8', 'Chrome', nil],
    ['Windows 7', 'Firefox', '38'],
    ['Windows 8.1', 'Internet Explorer', '11'],
    ['Windows 7', 'Internet Explorer', '9'],
    ['OS X 10.10', 'safari', '8.0'],
    ['OS X 10.10', 'iPhone', '8.2'],
    ['Linux', 'android', '5.1']
  ]
end
