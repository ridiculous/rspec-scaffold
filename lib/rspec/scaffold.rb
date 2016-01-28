require "pathname"
require "delegate"
require "rspec"
require "ryan"
require "highline"

module RSpec
  module Scaffold
    autoload :Version, "rspec/scaffold/version"
    autoload :Runner, "rspec/scaffold/runner"
    autoload :Generator, "rspec/scaffold/generator"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"

    def self.helper_file
      if defined?(::Rails) && RSpec::Core::Version::STRING.to_s >= '3'
        'rails_helper'
      else
        'spec_helper'
      end
    end
  end
end

load "rspec/scaffold/tasks/scaffold.rake"
