require "pathname"
require "delegate"
require "rspec"
require "ryan"
require "highline"

module RSpec
  module Scaffold
    autoload :Cli, "rspec/scaffold/cli"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"
    autoload :Generator, "rspec/scaffold/generator"
    autoload :Runner, "rspec/scaffold/runner"
    autoload :Version, "rspec/scaffold/version"

    # loads gem's rake tasks in main app
    # Dir["#{RSpec::Scaffold.root}" + "lib/rspec/scaffold/tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

    def self.helper_file
      if defined?(::Rails) && RSpec::Core::Version::STRING.to_s >= '3'
        'rails_helper'
      else
        'spec_helper'
      end
    end

    # RSpec::Scaffold.testify_file(filepath)
    # mode = :to_file, :to_text
    def self.testify_file(filepath, mode=:to_file)
      test_scaffold = RSpec::Scaffold::Runner.new(filepath).perform
      return test_scaffold
    end

    # RSpec::Scaffold.testify_text(text)
    def self.testify_text(text)
      test_scaffold = RSpec::Scaffold::Generator.new(text).perform
      return test_scaffold
    end

    def self.root
      Pathname.new File.expand_path('../../..', __FILE__)
    end

  end
end

load "rspec/scaffold/tasks/scaffold.rake"
