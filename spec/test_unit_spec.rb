# This is a RSpec spec to test TestUnit... yeah that's right

require 'spec_helper'
require 'test/unit'
require 'valid_attribute/test_unit'

describe 'Test::Unit::TestCase' do
  it '.have_valid' do
    Test::Unit::TestCase.have_valid(:name).should be_instance_of(ValidAttribute::ValidAttributeMatcher)
  end
end

