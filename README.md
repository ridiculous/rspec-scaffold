# RSpec::Scaffold

Generates RSpec scaffolding for existing code. Takes either a file or a directory.

## Installation

```ruby
gem 'rspec-scaffold'
```

## Usage

```bash
rake rspec:scaffold[lib]
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
rake rspec:scaffold[app/models/ability.rb]
```

Outputs:

```ruby
# spec/models/ability_spec.rb
require "spec_helper"

describe Ability do
  let(:user) {}

  subject { described_class.new user }

  describe "#initialize" do
    context "when user.admin?" do
      before {}
    end

    context "unless user.admin?" do
      before {}
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-scaffold.

