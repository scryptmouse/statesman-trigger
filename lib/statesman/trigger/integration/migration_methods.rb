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

          say_with_time "Creating Statesman trigger" do
            dump_statesman_params params

            say "create_statesman_trigger_function :#{params.function_name}", true
            say "create_statesman_trigger :#{params.trigger_name}", true

            connection.create_statesman_trigger params
          end
        end

        # @!macro migration_command
        def drop_statesman_trigger(*args)
          params = build_statesman_trigger_params(args)

          say_with_time "Dropping Statesman trigger" do
            dump_statesman_params params

            say "drop_statesman_trigger :#{params.trigger_name}", true
            say "drop_statesman_trigger_function :#{params.function_name}", true

            connection.drop_statesman_trigger params
          end
        end

        private
        # @param [Statesman::Trigger::Parameters] params
        # @return [void]
        def dump_statesman_params(params)
          params.for_inspect.each do |key, value|
            say "#{key}: #{value.inspect}", true
          end
        end
      end
    end
  end
end
