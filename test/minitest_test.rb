require 'test_helper'
require 'minitest/spec'
require 'valid_attribute/minitest'

describe 'MiniTest::Spec' do
  it '.have_valid' do
    have_valid(:name).must_be_instance_of(ValidAttribute::Matcher)
  end
end

