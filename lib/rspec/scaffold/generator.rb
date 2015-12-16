module RSpec
  module Scaffold
    class Generator < DelegateClass(Ryan)

      # = Class
      # generate a rspec file based on existing code

      attr_reader :file

      def initialize(file)
        @file = file
        super Ryan.new(file)
      end

      def const
        @const ||= Kernel.const_get(name)
      end

      def perform
        indent = (' ' * 2)
        second_indent = indent * 2
        lines = [%Q(require "#{helper_file}"), %Q(), %Q(describe #{const} do)]
        if class?
          initialization_args.each do |arg|
            lines << %Q(#{indent}let(:#{arg.to_s.sub(/^[&*]/, '')}) {})
          end
          lines << %Q()
          lines << %Q(#{indent}subject { described_class.new #{initialization_args.join(', ')} })
        elsif module?
          lines << %Q(#{indent}subject { Class.new { include #{const} }.new })
        end
        lines << %Q()
        funcs.reject(&:private?).each do |func|
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
        lines
      end

      def helper_file
        if defined?(::Rails)
          'rails_helper'
        else
          'spec_helper'
        end
      end
    end
  end
end
