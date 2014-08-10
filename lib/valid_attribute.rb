require 'valid_attribute/matcher'
require 'valid_attribute/method'

module ValidAttribute
  class NoValues < StandardError; end
end

if defined?(RSpec)
  require 'valid_attribute/rspec'
elsif defined?(Spec)
  require 'valid_attribute/spec'
elsif defined?(MiniTest::Matchers)
  require 'valid_attribute/minitest'
end
