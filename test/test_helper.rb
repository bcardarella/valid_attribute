require 'rubygems'
require 'bundler/setup'
require 'valid_attribute'
require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/mini_test'

class Minitest::Spec
  class << self
    alias :context :describe
  end
end
