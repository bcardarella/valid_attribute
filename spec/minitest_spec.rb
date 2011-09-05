require 'spec_helper'
require 'minitest/spec'
require 'valid_attribute/minitest'

describe 'MiniTest::Spec' do
  it '.have_valid' do
    MiniTest::Spec.have_valid(:name).should be_instance_of(ValidAttribute::Matcher)
  end
end

