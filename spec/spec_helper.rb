require 'rubygems'
require 'bundler'
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-debug'
require 'rspec'
require 'rspec/autorun'
require 'bourne'
require 'valid_attribute'

RSpec.configure do |config|
  config.mock_with :mocha
end


