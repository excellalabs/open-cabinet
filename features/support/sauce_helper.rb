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
    ['Windows 8.1', 'Internet Explorer', '11']
  ]
end
