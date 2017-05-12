require "rest-client"

class Model < ActiveRecord::Base
  module FancyExt
    extend ActiveSupport::Concern

    included do
      scope :scope_name, -> { all }
    end

    module ClassMethods
      def some_class_method(arg)

      end
    end

    def some_instance_method(arg)

    end

  end
end
