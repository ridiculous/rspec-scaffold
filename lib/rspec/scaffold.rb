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
    autoload :TextGenerator, "rspec/scaffold/text_generator"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"

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
      test_scaffold = RSpec::Scaffold::TextGenerator.new(text).perform
      return test_scaffold
    end

    def self.root
      current_file_name = __FILE__
      path_to_current_file = File.expand_path(current_file_name)
      root_path = Pathname.new(path_to_current_file) + "../../.."

      return root_path
    end
  end
end

load "rspec/scaffold/tasks/scaffold.rake"
