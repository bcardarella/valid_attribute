require 'rubygems'
require 'debugger' rescue nil
require 'bundler'
Bundler.require

RSpec.configure do |config|
  config.mock_with :mocha
end

