module Statesman
  module Trigger
    module Integration
      # Add support for statesman triggers to `ActiveRecord::Migration::CommandRecorder` in order to support reversible migrations.
      module CommandRecorderMethods
        extend ActiveSupport::Concern
        include Statesman::Trigger::Integration::SharedMethods

        # @!macro migration_command
        def create_statesman_trigger(*args, &block)
          record :create_statesman_trigger, build_statesman_trigger_options(args)
        end

        # @!macro migration_command
        def drop_statesman_trigger(*args, &block)
          record :drop_statesman_trigger, build_statesman_trigger_options(args)
        end

        # @return [(Symbol, Hash)]
        def invert_create_statesman_trigger(args, &block)
          [:drop_statesman_trigger, build_statesman_trigger_options(args)]
        end

        # @return [(Symbol, Hash)]
        def invert_drop_statesman_trigger(args, &block)
          [:create_statesman_trigger, build_statesman_trigger_options(args)]
        end
      end
    end
  end
end
