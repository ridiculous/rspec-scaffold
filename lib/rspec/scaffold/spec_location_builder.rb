module RSpec
  module Scaffold
    class SpecLocationBuilder
      # manages inferring spec file locations for code files.

      # @param [Pathname] project_root
      # @param [Pathname] file_path
      def initialize(project_root, file_path)
        @project_root = Pathname(project_root)
        @file_path    = Pathname(file_path)
        @relative_file_path = (@file_path.relative? ? Pathname(@file_path) : ( Pathname(@file_path.to_s.sub(@project_root.to_s, '')) ))
      end

      # RSpec::Scaffold::SpecLocationBuilder.new("/home/dev/projects/some_app", "/app/models/user.rb").spec_location
      def spec_location
        # for default rails app dir code
        @spec_location ||= if @relative_file_path.to_s[%r'\A/?app/']
          # replace first 'app/' with 'spec/' and change ending a bit
          @project_root.join(@relative_file_path.sub(%r'\A/?app/', 'spec/'))
        else
          @project_root.join("spec").join(@relative_file_path)
        end.sub(%r'\.rb\z', '_spec.rb')

        return @spec_location
      end

    end
  end
end
