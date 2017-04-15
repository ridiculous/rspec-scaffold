module RSpec
  module Scaffold
    class FileWriter
      # manages outputting test scaffolds to file.

      def initialize(output_file, output_text)
        @output_file = Pathname(output_file)
        @output_text = output_text
      end

      # RSpec::Scaffold::FileWriter.new("/path/to/file.rb", "yay, test scaffold!")
      def write!
        # 1. skip if file already exists.
        if output_file_already_exists?
          RSpec::Scaffold.log("- #{@output_file} - already exists", :puts)
          return
        end

        # 2. ensure parent directories exist
        FileUtils.makedirs(@output_file.parent)

        # 3. write to file
        File.open(@output_file, 'wb') do |f| # 'wb' originally
          f << @output_text
        end
        RSpec::Scaffold.log("+ #{@output_file}")

        return @output_file.to_s
      end

      private
        def output_file_already_exists?
          return @exists ||= @output_file.exist?
        end

    end
  end
end
