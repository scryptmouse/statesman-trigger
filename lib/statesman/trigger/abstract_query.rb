module Statesman
  module Trigger
    # @abstract
    class AbstractQuery
      include ActiveSupport::Configurable

      # @!attribute [r] parameters
      # @return [Statesman::Trigger::Parameters]
      attr_reader :parameters

      # @param [Statesman::Trigger::Parameters] parameters
      def initialize(parameters)
        @parameters = parameters
      end

      # @return [String] the formatted {#up_query} based on {#parameters}.
      def up
        up_query % parameters.for_query
      end

      # @return [String] the formatted {#down_query} based on {#parameters}.
      def down
        down_query % parameters.for_query
      end

      protected
      # @!attribute [r] up_query
      # @return [String]
      def up_query
        config.up_query.presence or raise 'Define up!'
      end

      # @!attribute [r] down_query
      # @return [String]
      def down_query
        config.down_query.presence or raise 'Define down!'
      end

      class << self
        # Set the {#up_query} SQL for this class.
        #
        # @param [String] raw_sql
        # @return [void]
        def up!(raw_sql)
          config.up_query = raw_sql.dedent
        end

        # Set the {#down_query} SQL for this class.
        #
        # @param [String] raw_sql
        # @return [void]
        def down!(raw_sql)
          config.down_query = raw_sql.dedent
        end
      end
    end
  end
end
