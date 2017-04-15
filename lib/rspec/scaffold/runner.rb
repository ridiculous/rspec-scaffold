module RSpec
  module Scaffold
    class Runner
      attr_reader :file

      # @param [Pathname] file
      def initialize(file = nil)
        @file = Pathname.new(file) if file
      end

      def perform
        fail ArgumentError, %Q(File or directory does not exist: "#{file}") if !File.exists?(file) && !File.exists?("#{file}.rb")

        ruby_files.each do |ruby_file|
          rspec_file = Pathname.new(spec_file(ruby_file))
          spec_file_path = rspec_file.to_s[%r|/(spec/.+)|, 1]
          next if rspec_file.exist?.tap { |exists| log "- #{spec_file_path} - already exists", :gray if exists }

          spec = generate_spec(Pathname.new(File.expand_path(ruby_file)))
          next unless spec

          log "+ #{spec_file_path}"
          FileUtils.mkdir_p(rspec_file.parent)
          File.open(rspec_file, 'wb') do |f|
            f << spec.join("\n")
          end
        end
      end

      # @param [String/Pathname] ruby
      def generate_spec(ruby)
        ryan = Ryan.new(ruby)
        if ryan.funcs.any?
          RSpec::Scaffold::Generator.new(ryan).perform
        else
          log "- #{truncate(ruby)} - no methods", :gray
          nil
        end
      rescue => e
        log "! #{truncate(ruby)} - #{e.inspect.gsub /^#<|>$/, ''}\n#{e.backtrace.take(10)}", :red
      end

      #
      # Private
      #

      def truncate(str)
        str.to_s.scan(/.+/).take(2).tap { |x| x[1..-1].each { |i| i[0..-1] = '...' } }.join
      end

      def ruby_files
        if File.directory?(file)
          Dir[File.join(file, '**', '*.rb')]
        else
          if file.extname.empty?
            ["#{file}.rb"]
          else
            [file]
          end
        end
      end

      # @note subbing out /app/ is Rails specific
      def spec_file(ruby_file)
        File.join(spec_path, "#{specify(ruby_file)}").sub '/app/', '/'
      end

      def specify(file_name)
        file_name.sub('.rb', '_spec.rb')
      end

      def spec_path
        if File.directory?(File.expand_path('spec'))
          File.expand_path('spec')
        else
          fail "Couldn't find spec directory"
        end
      end

      def log(msg = nil, color = :green)
        return RSpec::Scaffold.log(msg, color)
      end
    end
  end
end
