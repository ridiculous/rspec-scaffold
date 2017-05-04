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
        @parser = (parser.nil? ? @parser : parser)

        indent = (' ' * 2)
        second_indent = indent * 2

        # header
        lines = [
          %Q(# spring rspec),
          %Q(describe #{@parser.name} do)
        ]

        if @parser.class?
          @parser.initialization_args.each do |arg|
            lines << %Q(#{indent}let(:#{arg.to_s.sub(/^[&*]/, '')}) {})
          end
          lines << %Q()
          lines << %Q(#{indent}subject { described_class.new #{@parser.initialization_args.join(', ')} })
        elsif @parser.module?
          lines << %Q(#{indent}subject { Class.new { include #{@parser.name} }.new })
        end

        lines << %Q()

        # handle Rails model scopes
        if scope_definitions.any?
          lines << %Q|#{indent}describe 'Scopes' do|

          scope_definitions.each do |scope_name|
            lines << %Q|#{second_indent}describe '.#{scope_name}' do|
            lines << %Q|#{' ' * 6}xit "should collect TODO" do|
            lines << %Q|#{' ' * 6}end|
            lines << %Q|#{second_indent}end|
            lines << %Q||
          end

          lines << %Q|#{indent}end|
          lines << %Q()
        end

        # handle class and instance methods
        @parser.funcs.reject(&:private?).each do |func|
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
      end

      private

        def scope_definitions
          return @scope_definitions ||= scope_definitions_in_sexp(@parser.sexp)
        end

        def scope_definitions_in_sexp(sexp_or_symbol)
          # the sexp objects are not uniform, can not rely on specific array structure to exist
          #begin
          # binding.pry
          # sexp1 = [:block, sexp(:call, :include), sexp(:class, :Model, ...)]
          # sexp2 = [:call, nil, :scope]

          # handling_proc =
          is_a_cope_definition = begin
            sexp_or_symbol.respond_to?(:map) && sexp_or_symbol.to_a[2] == :scope
          rescue
            false
          end

          definitions = if is_a_cope_definition
            begin
              [sexp_or_symbol.to_a[3][1]] #=> scope symbol name
            rescue
              [nil]
            end
          elsif sexp_or_symbol.class == Sexp && sexp_or_symbol.size > 1
            # try looping over and going deeper
            sexp_or_symbol.map do |nested_sexp|
              if nested_sexp.class == Sexp && nested_sexp.size > 1 && nested_sexp[1] == :Model
                # there's nested_sexps, go deeper
                nested_sexp.map do |deep_nested_sexp|
                  scope_definitions_in_sexp(deep_nested_sexp)
                end
              else
                begin
                  [nested_sexp.to_a[3][1]] if nested_sexp.to_a[2] == :scope  #=> scope symbol name
                rescue
                  [nil]
                end
              end
            end
          else
            # sexp is actually a symbol, do nothing
            [nil]
          end

          return definitions.flatten.compact
        end

    end
  end
end
