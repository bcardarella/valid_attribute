require 'rubygems'
begin
  require 'debugger'
rescue LoadError
end
require 'bundler/setup'
require 'valid_attribute'

RSpec.configure do |config|
  config.mock_with :mocha
end
