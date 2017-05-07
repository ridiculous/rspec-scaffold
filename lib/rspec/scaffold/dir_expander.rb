module RSpec
  module Scaffold
    class DirExpander
      # manages recursively finding ruby files in directories.

      # @param [Pathname] input_dir
      def initialize(input_dir)
        @input_dir = Pathname(input_dir)
      end

      # RSpec::Scaffold::DirExpander.new("/path/to/dir")
      def expand_ruby_files
        # 1. Raise if not a directory
        raise(ArgumentError.new(%Q|"#{file}" is not a directory|)) if !@input_dir.directory?

        # 2. do the expansion of ruby files
        print ">> scanning #{@input_dir} tree for ruby files... "

        @ruby_files_in_tree ||= Dir.glob("#{@input_dir}/**/*.rb")

        puts "done"

        return @ruby_files_in_tree #=> ["/rspec-scaffold/spec/dummy/app/lib/some_service_class.rb"] array of strings
      end

    end
  end
end
