module Statesman
  module Trigger
    # @abstract
    class AbstractQuery
      include ActiveSupport::Configurable

      # @!attribute [r] parameters
      # @return [Statesman::Trigger::Parameters]
      attr_reader :parameters

      def initialize(parameters)
        @parameters = parameters
      end

      def up
        up_query % parameters.for_query
      end

      def down
        down_query % parameters.for_query
      end

      protected
      def up_query
        config.up_query.presence or raise 'Define up!'
      end

      def down_query
        config.down_query.presence or raise 'Define down!'
      end

      class << self
        def up!(raw_sql)
          config.up_query = raw_sql.dedent
        end

        def down!(raw_sql)
          config.down_query = raw_sql.dedent
        end
      end
    end
  end
end
