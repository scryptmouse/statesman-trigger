module Statesman
  module Trigger
    class NullObject
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def inspect
        %[#{self.class}(:name => :#{name})]
      end

      def method_missing(method, *args, &block)
        raise NoMethodError, "You must provide :#{name} that responds to :#{method}"
      end
    end
  end
end
