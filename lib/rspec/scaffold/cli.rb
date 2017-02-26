module RSpec
  module Scaffold
    class Cli

      def self.start#(args)
        puts help_string
      end

      private

        def help_string
          help_string = <<-ENDBAR
Usage: rspec-scaffold <options> PATH

Common use cases:
  1) file in -> file out | rspec-scaffold "path/to/code.rb"
  2) directory in -> files out | rspec-scaffold "path/to/code/directory"
  3) output to STDOUT instead of files | rspec-scaffold -t "path/to/code.rb"
          ENDBAR
        end

    end
  end
end
