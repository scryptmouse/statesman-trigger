module Statesman
  module Trigger
    # Created by {Parameters#default_model_klass} or {Parameters#default_transition_klass}
    # to raise errors if there is an attempt to introspect
    # @api private
    class NullObject
      # @!attribute [r] name
      # Name of the parameter used by {Parameters}
      # @return [String]
      attr_reader :name

      # @param [String, Symbol] name
      def initialize(name)
        @name = name
      end

      # @return [String]
      def inspect
        %[#{self.class}(:name => :#{name})]
      end

      # @param [Symbol] method
      # @raise [Statesman::Trigger::IntrospectionError] with the name of the method that should exist on {#name}.
      # @return [void]
      def method_missing(method, *args, &block)
        raise Statesman::Trigger::IntrospectionError, "You must provide :#{name} that responds to :#{method}"
      end
    end
  end
end
