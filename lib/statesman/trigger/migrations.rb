module Statesman
  module Trigger

    # Integrates with CommandRecorder
    #
    # @api private
    module Migrations
      extend ActiveSupport::Concern
      include Statesman::Trigger::SharedMethods

      def create_statesman_trigger(*args, &block)
        record :create_statesman_trigger, build_statesman_trigger_options(args)
      end

      def drop_statesman_trigger(*args, &block)
        record :drop_statesman_trigger, build_statesman_trigger_options(args)
      end

      def invert_create_statesman_trigger(args, &block)
        [:drop_statesman_trigger, build_statesman_trigger_options(args)]
      end

      def invert_drop_statesman_trigger(args, &block)
        [:create_statesman_trigger, build_statesman_trigger_options(args)]
      end
    end
  end
end
