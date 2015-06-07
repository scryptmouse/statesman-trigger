module Statesman
  module Trigger
    module Integration
      # Integration with `ActiveRecord::ConnectionAdapters::AbstractAdapter`
      #
      # @note only Postgres is currently supported.
      module AdapterMethods
        extend ActiveSupport::Concern
        include Statesman::Trigger::Integration::SharedMethods

        # @!macro migration_command
        def create_statesman_trigger(*args)
          statesman_trigger_requires_pg!

          params = build_statesman_trigger_params args

          validation_query = params.build_validation_query

          raise "target column `#{params.sync_column}` not found on `#{params.model_table}`." unless select_value(validation_query)

          params.build_statements(direction: :up).map do |stmt|
            execute stmt
          end
        end

        # @!macro migration_command
        def drop_statesman_trigger(*args)
          statesman_trigger_requires_pg!

          params = build_statesman_trigger_params args

          params.build_statements(direction: :down).map do |stmt|
            execute stmt
          end
        end

        # @api private
        # @raise [RuntimeError] if adapter is not postgres
        # @return [void]
        def statesman_trigger_requires_pg!
          raise 'Requires postgres' unless adapter_name =~ /postg/i
        end
      end
    end
  end
end
