require 'valid_attribute/matcher'
require 'valid_attribute/method'

module ValidAttribute
  class NoValues < StandardError; end
end

if defined?(RSpec)
  require 'valid_attribute/rspec'
else
  require 'valid_attribute/test_unit'
end
