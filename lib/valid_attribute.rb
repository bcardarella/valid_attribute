require 'valid_attribute/matcher'

module ValidAttribute
  class NoValues < StandardError; end
  # Test if an attribute is valid
  #
  # examples:
  #  it { should have_valid(:name).when('Brian') }
  #  it { should_not have_valid(:name).when(nil) }
  #  it { should have_valid(:email).when('test@test.com', 'test+spam@gmail.com') }
  #  it { should_not have_valid(:email).when('abc', 123) }
  #
  # @param [Symbol]
  #
  # @return [ValidAttribute::ValidAttributeMatcher]
  def have_valid(attr)
    ValidAttributeMatcher.new(attr)
  end
end

if defined?(RSpec)
  require 'valid_attribute/rspec'
else
  require 'valid_attribute/test_unit'
end

