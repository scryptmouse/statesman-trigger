module Statesman
  module Trigger
    module Integration
      extend ActiveSupport::Concern

      def create_statesman_trigger(options = {})
        statesman_trigger_requires_pg!

        params = Statesman::Trigger::Parameters.new options

        validation_query = params.build_validation_query

        raise "target column `#{params.sync_column}` not found on `#{params.model_table}`." unless select_value(validation_query)

        params.build_statements(direction: :up).map do |stmt|
          execute stmt
        end
      end

      def drop_statesman_trigger(options = {})
        statesman_trigger_requires_pg!

        params = Statesman::Trigger::Parameters.new options

        params.build_statements(direction: :down).map do |stmt|
          execute stmt
        end
      end

      def statesman_trigger_requires_pg!
        raise 'Requires postgres' unless adapter_name =~ /postg/i
      end
    end
  end
end
