# You should edit this file with the browsers you wish to use
# For options, check out http://saucelabs.com/docs/platforms
require 'sauce'
require 'sauce/cucumber'
require 'sauce/capybara'

Sauce.config do |config|
 # config[:application_host] = "http://#{ENV['STACK_URL']}"
  config[:start_tunnel] = ENV['SAUCE_LABS']
  config[:start_local_application] = true
  config[:browsers] = [
    ['Windows 8', 'Chrome', nil],
    ['Windows 7', 'Firefox', '20'],
    ['OS X 10.10', 'chrome', '39.0'],
    ['Windows 7', 'Internet Explorer', '9'],
    ['iPhone Simulator', 'iphone'],
    ['Windows 8.1', 'Internet Explorer', '11'],
    ['Windows 8.1', 'Internet Explorer', '11']
  ]
end
