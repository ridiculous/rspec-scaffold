# RSpec Scaffolding [![Build Status](https://travis-ci.org/ridiculous/rspec-scaffold.svg)](https://travis-ci.org/ridiculous/rspec-scaffold)

Generates RSpec scaffolding for existing code.  
Helps you write tests by showing you what you should be testing, which are conditions and changes to state (at a minimum).

## Installation

Requires Ruby >= 1.9.3

```ruby
gem 'rspec-scaffold', '~> 2.0.0.beta1'
```

## Caveats
Works best if used from within a Rails app root and if the project has the spec/ directory (it should!).  

## Usage
The gem provides a command line utility `rspec-scaffold` for working with existing files, and simple-to-use module methods for programmatic use.

### The CLI
Only operates on filepaths.  

```bash
# file in -> file out
rspec-scaffold "path/to/code.rb"

# or for a directory
rspec-scaffold -d "path/to/code/directory"

# output to STDOUT instead of file
rspec-scaffold -t "path/to/code.rb"
```

### The methods

Three scenarios are supported:

#### 1. Provide ruby code -> get scaffold string (not supported by CLI since it would be cumbersome)
```rb
  RSpec::Scaffold.testify_text(text)  
```

#### 2. Provide ruby code file(s) -> get scaffold string
```rb
  RSpec::Scaffold.testify_file(filepath, :to_text)
```

#### 3. Provide ruby code file(s) -> get scaffold file(s)
```rb
  RSpec::Scaffold.testify_file(filepath, :to_file)  
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
rspec-scaffold "path/to/code.rb"
```

Outputs to 'spec/models/ability_spec.rb':

```ruby
# rspec spec/models/ability_spec.rb
describe Ability do
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ridiculous/rspec-scaffold.
