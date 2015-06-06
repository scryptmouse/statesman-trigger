module Statesman
  module Trigger
    module Integration
      extend ActiveSupport::Concern
      include Statesman::Trigger::SharedMethods

      def create_statesman_trigger(*args)
        statesman_trigger_requires_pg!

        params = Statesman::Trigger::Parameters.new build_statesman_trigger_options(args)

        validation_query = params.build_validation_query

        raise "target column `#{params.sync_column}` not found on `#{params.model_table}`." unless select_value(validation_query)

        params.build_statements(direction: :up).map do |stmt|
          execute stmt
        end
      end

      def drop_statesman_trigger(*args)
        statesman_trigger_requires_pg!

        params = Statesman::Trigger::Parameters.new build_statesman_trigger_options(args)

        params.build_statements(direction: :down).map do |stmt|
          execute stmt
        end
      end

      def statesman_trigger_requires_pg!
        raise 'Requires postgres' unless adapter_name =~ /postg/i
      end

      # @return [Hash]
      def build_statesman_trigger_options(args)
        super.first
      end
    end
  end
end
