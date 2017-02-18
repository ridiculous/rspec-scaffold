module RSpec
  module Scaffold
    class Generator < DelegateClass(Ryan)

      # = Class
      # generate a rspec file based on existing code
      # Accepts a single file path argument and delegates processing to text builder

      attr_reader :file

      # RSpec::Scaffold::Generator.new("app/models/user.rb")
      def initialize(file)
        @file = file
        return RSpec::Scaffold::TextGenerator.new(File.read(file))
      end

    end
  end
end
