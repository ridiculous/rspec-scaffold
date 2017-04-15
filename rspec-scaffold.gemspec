# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/scaffold/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-scaffold"
  spec.version       = RSpec::Scaffold::VERSION
  spec.authors       = ["Ryan Buckley"]
  spec.email         = ["arebuckley@gmail.com"]

  spec.summary       = %q{Generates RSpec scaffolding for existing code}
  spec.description   = %q{Generates RSpec scaffolding for conditions and ivar assignments}
  spec.homepage      = "https://github.com/ridiculous/rspec-scaffold"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = ["rspec-scaffold"] # spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'highline', '~> 1.6'
  spec.add_dependency 'ryan', '~> 1.1.0'

  spec.add_dependency "pry", "~> 0.10.4"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", ">= 3.2", "< 4"
  # spec.add_development_dependency "pry", "~> 0.10.4"
  spec.add_development_dependency "simplecov", "~> 0.13.0"
  spec.add_development_dependency "fakefs", "~> 0.11.0" # fakes filesystem, useful for testing file outputs.
end
