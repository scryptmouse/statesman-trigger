require "statesman/trigger/version"
require "active_support/all"
require "active_record"
require "pg"
require "virtus"
require "dedent"

# Namespace for [Statesman gem](https://github.com/gocardless/statesman).
module Statesman
  # Namespace for this gem.
  module Trigger
    require_relative './trigger/null_object'
    require_relative './trigger/parameters'
    require_relative './trigger/abstract_query'
    require_relative './trigger/trigger_query'
    require_relative './trigger/update_function_query'
    require_relative './trigger/shared_methods'
    require_relative './trigger/integration'
    require_relative './trigger/migrations'
  end
end

ActiveSupport.on_load :active_record do
  ActiveRecord::ConnectionAdapters::AbstractAdapter.include Statesman::Trigger::Integration
  ActiveRecord::Migration::CommandRecorder.include Statesman::Trigger::Migrations
end
