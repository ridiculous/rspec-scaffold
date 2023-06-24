# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.1] - 2023-06-24
- Drop `highline` dependency since it's not used anymore

## [2.0.0] - 2023-06-24
- Update this repo to work with ruby 2.7.8 (ryan throwing frozen error)
- Release 2.0 finally so that readme matches default gem download

## [2.0.0.beta1] - 2017-05-12
### Added
- Convenience methods `RSpec::Scaffold.testify_file` and `RSpec::Scaffold.testify_text` which allow making scaffolds from within code.
- rspec-scaffold CLI

### Changed
- Scaffolds no longer produce the 'require spec/rails_helper' line - devs should keep it in .rspec file.
- Updates to Rails controller scaffolds
- Updates to Rails Model scaffolds

## [1.0.0] - 2016-08-05
Core functionality, `rake rspec:scaffold[app/models/ability.rb]`.  
