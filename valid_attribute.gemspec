# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "valid_attribute/version"

Gem::Specification.new do |s|
  s.name        = "valid_attribute"
  s.version     = ValidAttribute::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Cardarella"]
  s.email       = ["bcardarella@gmail.com"]
  s.homepage    = "https://github.com/bcardarella/valid_attribute"
  s.summary     = %q{Minimalist validation matcher}
  s.description = %q{Minimalist validation matcher}

  s.rubyforge_project = "valid_attribute"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'bourne'
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency 'ruby-debug19'
  else
    s.add_development_dependency 'ruby-debug'
  end
end
