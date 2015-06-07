module Statesman
  module Trigger
    # Integration with ActiveRecord.
    module Integration
      extend ActiveSupport::Concern

      require_relative './integration/shared_methods'
      require_relative './integration/adapter_methods'
      require_relative './integration/command_recorder_methods'
      require_relative './integration/migration_methods'

      class << self
        # Used in an `ActiveSupport.on_load :active_record` callback to install the ActiveRecord integrations.
        #
        # @return [void]
        def install!
          ActiveRecord::ConnectionAdapters::AbstractAdapter.include Statesman::Trigger::Integration::AdapterMethods
          ActiveRecord::Migration::CommandRecorder.include Statesman::Trigger::Integration::CommandRecorderMethods
          ActiveRecord::Migration.include Statesman::Trigger::Integration::MigrationMethods
        end
      end
    end
  end
end
