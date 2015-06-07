module Statesman
  module Trigger
    module Integration
      # Adds support for statesman triggers to `ActiveRecord::Migration`.
      module MigrationMethods
        extend ActiveSupport::Concern
        include Statesman::Trigger::Integration::SharedMethods

        # @!macro migration_command
        def create_statesman_trigger(*args)
          params = build_statesman_trigger_params(args)

          say_with_time "create_statesman_trigger(#{params.inspect})" do
            connection.create_statesman_trigger params
          end
        end

        # @!macro migration_command
        def drop_statesman_trigger(*args)
          params = build_statesman_trigger_params(args)

          say_with_time "drop_statesman_trigger(#{params.inspect})" do
            connection.drop_statesman_trigger params
          end
        end
      end
    end
  end
end
