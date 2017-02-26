module RSpec
  module Scaffold
    class Cli

      # This method will be run as a script and uses on ARGV hash contents
      def self.start
        # binding.pry

        # puts "detected path argument as '#{path_argument}'"

        if path_argument.nil? || options.include?("-h") || options.include?("--help")
          puts help_string
          abort
        else
          # all is set for processing
          if options.include?("-t") || options.include?("--text")
            RSpec::Scaffold.testify_file(path_argument, :to_text)
          else
            # make spec files, default behavior
            RSpec::Scaffold.testify_file(path_argument)
          end
        end
      end

      private

        def self.help_string
          help_string = <<-ENDBAR
Build RSpec tests scaffolds for existing ruby code.

Usage: rspec-scaffold <options> PATH

Available options:
  -h, --help Prints this message
  -t, --text Outputs scaffold(s) to STDOUT instead of spec files

Common use cases:
  1) file in -> file out | rspec-scaffold "path/to/code.rb"
  2) directory in -> files out | rspec-scaffold "path/to/code/directory"
  3) output to STDOUT instead of files | rspec-scaffold -t "path/to/code.rb"
          ENDBAR

          return help_string.strip.gsub(%r'\A\s+', '')
        end

        def self.options
          options = ARGV.select{|arg| arg[0] == "-" && arg.size > 1}.map do |arg|
            # unpack several singledash options
            if !!arg == true && arg[1] != "-"
              arg.split("")[1..-1].map{|letter| "-#{letter}"}
            else
              arg
            end
          end.flatten

          return options
        end

        def self.path_argument
          path_argument = (!!ARGV[-1] == true && ARGV[-1][0] != "-" ? ARGV[-1] : nil)

          return path_argument
        end

    end
  end
end
