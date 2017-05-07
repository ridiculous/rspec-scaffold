require "pathname"
require "delegate"
#require "rspec"
require "ryan"
require "luks"
require 'pry'

module RSpec
  module Scaffold
    autoload :Cli, "rspec/scaffold/cli"
    autoload :ConditionExhibit, "rspec/scaffold/condition_exhibit"
    autoload :FileWriter, "rspec/scaffold/file_writer"
    autoload :Generator, "rspec/scaffold/generator"
    autoload :DirExpander, "rspec/scaffold/dir_expander"
    autoload :Runner, "rspec/scaffold/runner"
    autoload :SpecLocationBuilder, "rspec/scaffold/spec_location_builder"
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
    def self.testify_file(filepath, mode=:to_text, out: nil)
      begin
        test_scaffold = RSpec::Scaffold::Generator.new(Ryan.new(filepath)).perform
      rescue => e
        RSpec::Scaffold.log("- parse error in '#{filepath}': #{e.message}", :red)
        return nil
      end

      scaffold_text = test_scaffold.join("\n")

      if out
        return RSpec::Scaffold::FileWriter.new(out, scaffold_text).write!
      else
        case mode
        when :to_file
          output_filename = filepath.sub(%r'\.rb\z', '_spec.rb')
          return RSpec::Scaffold::FileWriter.new(output_filename, scaffold_text).write!
        when :to_text
          return scaffold_text
        else
          raise("Unrecognized mode")
        end
      end
    end

    # RSpec::Scaffold.testify_text(text)
    def self.testify_text(text)
      test_scaffold = RSpec::Scaffold::Generator.new(Ryan.new(text)).perform
      return test_scaffold.join("\n")
    rescue => e
      message = "parse error: #{e.message}"
      RSpec::Scaffold.log(message, :red)
      return message
    end

    def self.root
      Pathname.new File.expand_path('../../..', __FILE__)
    end

    # refactored from runner for more general use
    def self.log(msg = nil, color = :green)
      return send(color, "  #{msg}")
    end

  end
end

load "rspec/scaffold/tasks/scaffold.rake"
