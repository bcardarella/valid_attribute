# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'valid_attribute/version'

Gem::Specification.new do |s|
  s.name          = 'valid_attribute'
  s.version       = ValidAttribute::VERSION
  s.authors       = ['Brian Cardarella']
  s.email         = ['bcardarella@gmail.com']
  s.homepage      = 'https://github.com/bcardarella/valid_attribute'
  s.summary       = %q{Minimalist validation matcher}
  s.description   = %q{Minimalist validation matcher}
  s.license       = 'MIT'
  s.files         = Dir['{lib}/**/*'] + ['README.md']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-matchers'
end
