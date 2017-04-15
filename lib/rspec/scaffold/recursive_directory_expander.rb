module RSpec
  module Scaffold
    class RecursiveDirectoryExpander
      # manages recursively finding ruby files in directories.

      # @param [Pathname] input_dir
      def initialize(input_dir)
        @input_dir = Pathname(input_dir)
      end

      # RSpec::Scaffold::RecursiveDirectoryExpander.new("/path/to/dir")
      def expand_ruby_files
        # 1. Raise if not a directory
        raise(ArgumentError.new(%Q|"#{file}" is not a directory|) if !@input_dir.directory?

        # 2. do the recursive expansion of ruby files
        print ">> Recursively scanning #{@input_dir} for ruby files... "

        @ruby_files_in_tree ||= Dir.glob("#{@input_dir}/**/*.rb")

        puts "done"

        binding.pry

        return @ruby_files_in_tree
      end

    end
  end
end
