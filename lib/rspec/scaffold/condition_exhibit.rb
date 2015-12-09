module RSpec
  module Scaffold
    class ConditionExhibit < DelegateClass(Ryan::Condition)

      attr_reader :second_indent, :indent

      def initialize(condition, indent = '    ')
        super(condition)
        @indent, @second_indent = indent, indent + (' ' * 2)
      end

      # @param [Array] contexts just used for recursive calls
      # @return [Array]
      def render(contexts = [])
        contexts.concat(context(:statement, [:edit_prefix, :escape]) do |lines|
          lines.concat it(:if_text, :escape)
          lines << %Q() if nested_conditions.any?
          nested_conditions.each { |nc| self.class.new(nc, second_indent).render(lines) }
          lines
        end)
        contexts << %Q()
        if parts.empty?
          contexts.concat(context(:statement, [:negate, :edit_prefix, :escape]) do |lines|
            lines.concat it(:else_text, :escape)
          end)
        end
        parts.each do |condition_part|
          contexts.concat conditional_parts(condition_part)
        end
        contexts
      end

      #
      # Private
      #

      def context(*args)
        list = [%Q(#{indent}context #{call_with_modifiers(*args)} do), %Q(#{second_indent}before {})]
        yield list if block_given?
        list << %Q(#{indent}end)
        list
      end

      def it(*args)
        return [] unless we_should_print? public_send(args.first)
        [%Q(), %Q(#{second_indent}it #{call_with_modifiers(*args)} do), %Q(#{second_indent}end)]
      end

      def call_with_modifiers(method_name, modifiers = [])
        Array(modifiers).inject(public_send(method_name)) { |txt, modifier| public_send(modifier, txt) }
      end

      def conditional_parts(condition_part, contexts = [])
        condition_part = self.class.new(condition_part, indent)
        contexts.concat(condition_part.context(:statement, [:edit_prefix, :escape]) do |lines|
          lines.concat condition_part.it(:if_text, :escape)
        end)
        if condition_part.should_print? condition_part.else_text
          contexts.concat(condition_part.context(:statement, [:negate, :edit_prefix, :escape]) do |lines|
            lines.concat condition_part.it(:else_text, :escape)
          end)
        end
        contexts
      end

      def escape(txt)
        txt.gsub!(/#\{(.*?)\}/m, '\#{\1}') # escape interpolations
        txt.gsub!(/"/m, "'") # replace double quotes with single quotes
        %Q("#{truncate(txt)}")
      end

      def truncate(txt, length = 120)
        txt = txt.lstrip
        length -= 3
        if txt.length > length
          txt[0, length] + '...'
        else
          txt
        end
      end

      def negate(txt)
        if txt[/^unless /]
          txt.sub /^unless /, 'if '
        else
          "not #{txt}"
        end
      end

      def edit_prefix(txt)
        txt.sub! /^if /, 'when '
        txt.sub! /^not if /, 'unless '
        txt.sub! /^if not /, 'unless '
        if txt !~ /^(when|unless|not)/
          txt = "when #{txt}"
        end
        txt
      end

      def we_should_print?(txt)
        !txt.empty? and txt !~ /\n/
      end

      alias should_print? we_should_print?
    end
  end
end
