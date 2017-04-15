require "pathname"
require "delegate"
#require "rspec"
require "ryan"
require "highline"
require 'pry'

module RSpec
  module Scaffold
    autoload :Cli, "rspec/scaffold/cli"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"
    autoload :FileWriter, "rspec/scaffold/file_writer"
    autoload :Generator, "rspec/scaffold/generator"
    autoload :Runner, "rspec/scaffold/runner"
    autoload :Version, "rspec/scaffold/version"

    # loads gem's rake tasks in main app
    # Dir["#{RSpec::Scaffold.root}" + "lib/rspec/scaffold/tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

    # DEPRECATED
    def self.helper_file
      if Object.const_defined?("Rails") && RSpec::Core::Version::STRING.to_s >= '3'
        'rails_helper'
      else
        'spec_helper'
      end
    end

    # RSpec::Scaffold.testify_file(filepath)
    # mode = :to_file, :to_text
    def self.testify_file(filepath, mode=:to_text, output_file=nil)
      test_scaffold = RSpec::Scaffold::Generator.new(Ryan.new(filepath)).perform
      scaffold_text = test_scaffold.join("\n")

      case mode
      when :to_file
        output_filename = (output_file.nil? ? filepath.sub(%r'\.rb\z', '_spec.rb') : output_file)
        return RSpec::Scaffold::FileWriter.new(output_filename, scaffold_text).write!
      when :to_text
        return scaffold_text
      else
        raise("Unrecognized mode")
      end
    end

    # RSpec::Scaffold.testify_text(text)
    def self.testify_text(text)
      test_scaffold = RSpec::Scaffold::Generator.new(Ryan.new(text)).perform
      return test_scaffold.join("\n")
    end

    def self.root
      Pathname.new File.expand_path('../../..', __FILE__)
    end

    # refactored from runner for more general use
    def self.log(msg = nil, color = :green)
      HighLine.new.say %Q(  <%= color('#{msg}', :#{color}) %>)
    end

  end
end

load "rspec/scaffold/tasks/scaffold.rake"
