require 'rubygems'
require 'bundler'
Bundler.require

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'
require 'rspec/autorun'
require 'bourne'
require 'valid_attribute'
require 'debugger'

RSpec.configure do |config|
  config.mock_with :mocha
end


