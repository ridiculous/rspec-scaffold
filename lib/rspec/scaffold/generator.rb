module RSpec
  module Scaffold
    class Generator
      # Generates an array of lines that can be joined into an RSpec file based.
      #
      # @param [Ryan,#name,#funcs,#initialization_args,#class?,#module?] parser object that is used to build the rspec file

      def initialize(parser)
        @parser = parser
      end

      def perform(parser=nil)
        # for backwards compat with arg to perform
        parser ||= @parser

        indent = (' ' * 2)
        second_indent = indent * 2
        lines = [%Q(# spring rspec), %Q(describe #{parser.name} do)]
        if parser.class?
          parser.initialization_args.each do |arg|
            lines << %Q(#{indent}let(:#{arg.to_s.sub(/^[&*]/, '')}) {})
          end
          lines << %Q()
          lines << %Q(#{indent}subject { described_class.new #{parser.initialization_args.join(', ')} })
        elsif parser.module?
          lines << %Q(#{indent}subject { Class.new { include #{parser.name} }.new })
        end

        lines << %Q()

        parser.funcs.reject(&:private?).each do |func|
          lines << %Q(#{indent}describe "#{func.class? ? '.' : '#'}#{func.name}" do)
          func.assignments.each do |assignment|
            lines << %Q(#{second_indent}it "#{assignment}" do) << %Q(#{second_indent}end)
          end
          lines << %Q() if func.conditions.any? and func.assignments.any?
          func.conditions.each do |condition|
            lines.concat ConditionExhibit.new(condition, second_indent).render
          end
          lines << %Q(#{indent}end) << %Q()
        end

        lines << %Q(end) << %Q()

        return lines
      rescue => e
        raise Racc::ParseError.new(e.message)
      end

    end
  end
end
