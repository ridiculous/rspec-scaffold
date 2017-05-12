# RSpec Scaffold [![Build Status](https://travis-ci.org/ridiculous/rspec-scaffold.svg)](https://travis-ci.org/ridiculous/rspec-scaffold)

Generates RSpec scaffolding for existing code.  
Cleverly infers spec location from source file location.   
Helps you write tests by showing you what you should be testing, which are conditions and changes to state (at a minimum).

## Installation

Requires Ruby >= 1.9.3

__1. update gemfile and bundle__

```ruby
gem 'rspec-scaffold', '~> 2.0.0.beta1', require: false
```

__2. see if it works__

```
rspec-scaffold
```

## Caveats
Works best if used from within a Rails app root and if the project has the spec/ directory (it should!).  

## Usage
The gem provides a command line utility `rspec-scaffold` for working with existing files, and simple-to-use module methods for programmatic use.  
The idea is to point to existing ruby code files and `rspec-scaffold` will ensure corresponding spec files in `/spec` directory.  

### The CLI
Only handles files/directories. If you want to feed in raw code, use the module methods.  

__file in -> file out__

```bash
rspec-scaffold "path/to/code.rb"
```

__directory in -> files out__

```bash
# pass -y option to pre-agree to many spec file creation
rspec-scaffold "app/models/"
```

__output to STDOUT instead of file__

```bash
rspec-scaffold -t "path/to/code.rb"  
```

### The methods

Three scenarios are supported:

__1. Provide ruby code -> get scaffold string (not supported by CLI since it would be cumbersome)__

```rb
RSpec::Scaffold.testify_text(text)  
```

__2. Provide ruby code file(s) -> get scaffold string__

```rb
RSpec::Scaffold.testify_file(filepath, :to_text)
```

__3. Provide ruby code file(s) -> get scaffold file(s)__

```rb
RSpec::Scaffold.testify_file(filepath, out: "/optional/custom/output/file.rb")  
```

## Example

Given:

```ruby
# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :update, User do |u|
        u.id == user.id
      end
    end
  end
end
```

```bash
rspec-scaffold "app/models/ability.rb"
```

Outputs to 'spec/models/ability_spec.rb':

```ruby
# rspec spec/models/ability_spec.rb
describe Ability, type: :model do
  klass = Ability
  let(:user) {}

  describe "#initialize" do
    context "when user.admin?" do
      xit "should " do
        expect(0).to eq 1
      end
    end

    context "unless user.admin?" do
      xit "should " do
        expect(0).to eq 1
      end
    end
  end

end
```

## TODO
* Have scaffolds be aware of method arguments, especially keyword ones.  
* Have concern scaffolds output which module it is they are for.  
* Have concern scaffolds recognize methods defined within `module ClassMethods` as class methods.  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ridiculous/rspec-scaffold.
