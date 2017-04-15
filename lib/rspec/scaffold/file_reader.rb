module RSpec
  module Scaffold
    class FileReader
      # manages reading ruby file contents.

      # @param [Pathname] input_file
      def initialize(input_file)
        @input_file = Pathname(input_file)
      end

      # RSpec::Scaffold::FileReader.new("/path/to/file.rb")
      def read
        # 1. Fail miserably if the file does not exist
        # fail ArgumentError, %Q(File or directory does not exist: "#{file}") if !File.exists?(file) && !File.exists?("#{file}.rb")

        print ">> Reading #{@input_file}... "

        @read ||= File.read(@input_file)

        puts "done"

        return @read
      end

    end
  end
end
