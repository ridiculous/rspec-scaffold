module RSpec
  module Scaffold
    class Cli
      # This class handles `rspec=scaffold` command runs from command line.

      # this method allows simple testing since it, unlike ARGV constant, can be mocked.
      def self.command_line_arguments
        return ARGV # => ["-t", "-y", "/some/path"] or ["-ty", "/some/path"]
      end

      # @param [Pathname] boot_path
      def initialize(boot_path)
        @boot_path = boot_path
        @command_line_arguments = send(:class).command_line_arguments
      end

      # This method will be run as a script and uses on ARGV hash contents
      def start
        if path_argument.nil? || options.include?("h")
          puts help_string
          abort
        else
          # 0. see if passed file/dir exists and is in boot_path tree.
          if !file_or_dir.exist?
            puts "The file or dir you passed does not exist in project root!"
          end

          # 1. must process path argument to determine whether it is a single file or a dir.
          @processable_files = if file_or_dir.directory?
            RSpec::Scaffold::RecursiveDirectoryExpander.new(file_or_dir).expand_ruby_files
          else
            # file_or_dir.file?
            [file_or_dir]
          end

          # 2. verify processing if there are numerous files and -y is not given
          if many_processable_file_danger? && !argumented_agreeing?
            puts "Many files are about to be processed. Are you sure?"
            abort unless STDING.gets.strip[%r'\Ay'i]
          end

          # 2. once path processing is done, array of files (sometimes and array of one file) is looped over
          @processable_files.each do |processable_file|
            # all is set for processing
            if options.include?("t")
              RSpec::Scaffold.testify_file(path_argument, :to_text)
            else
              # output to spec files, core behavior
              RSpec::Scaffold.testify_file(path_argument, :to_file)
            end
          end

        end

        return true
      end

      private

        self::OPTIONS = {
          "--help" => "h",
          "--text" => "t",
        }.freeze

        def options
          @options ||= @command_line_arguments.select{|arg| arg[0] == "-" && arg.size > 1}.map do |arg|
            if !!arg == true && arg[1] != "-"
              # unpack several singledash options
              arg.split("")[1..-1]
            else
              # making doubledash options into singledash
              send(:class)::OPTIONS[arg]
            end
          end.flatten.uniq.join("")

          return @options #=> "hty"
        end

        def argumented_agreeing?
          return options.include?("y")
        end

        def many_processable_file_danger?
          return 5 < processable_files.size
        end

        def path_argument
          @path_argument ||= (!!@command_line_arguments[-1] == true && @command_line_arguments[-1][0] != "-" ? @command_line_arguments[-1] : nil)

          return @path_argument
        end

        def file_or_dir
          return nil if path_argument.nil?

          @file_or_dir ||= findable_pathname

          return @file_or_dir
        end

        def findable_pathname
          return @findable_pathname ||= Pathname("#{@boot_path}#{path_argument}")
        end

        def help_string
          help_string = <<-ENDBAR
Build RSpec tests scaffolds for existing ruby code.

Usage:
  rspec-scaffold <options> PATH

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

        def boot_and_path_mismatch_warning_string
          warning_string = <<-ENDBAR
Command boot path and argument path mismatch detected!

Command booted from: '#{}'
Path argument was: '#{}'

Are you running rspec-scaffold from project root?
          ENDBAR

          return warning_string.strip.gsub(%r'\A\s+', '')
        end

    end
  end
end
