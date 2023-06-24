# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/scaffold/version'

Gem::Specification.new do |spec|
  spec.name    = "rspec-scaffold"
  spec.version = RSpec::Scaffold::VERSION
  spec.authors = ["Ryan Buckley"]
  spec.email   = ["arebuckley@gmail.com"]

  spec.summary     = %q{Generates RSpec scaffolding for existing code}
  spec.description = %q{Generates test files based on your codes logic, setting up the initialization args and nested context blocks}
  spec.homepage    = "https://github.com/ridiculous/rspec-scaffold"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = ["rspec-scaffold"] # NB, as of bundler 0.12, executables *must* be in /exe
  spec.require_paths = ["lib"]
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'luks' # , '~> 1.6'
  spec.add_dependency 'ryan', '~> 1.2.1'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", ">= 3.2", "< 5"
  spec.add_development_dependency "fakefs", "~> 0.11.0" # fakes filesystem, useful for testing file outputs.
  spec.add_development_dependency "rake-release", "~> 1.3.0"
end
