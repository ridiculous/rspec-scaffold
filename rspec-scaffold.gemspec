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
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'highline', '~> 1.7'
  spec.add_dependency 'ryan', '~> 1.0'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", ">= 3.2", "< 4"
end
