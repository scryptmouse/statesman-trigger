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
    # Raised when a value can't be introspected
    class IntrospectionError < NoMethodError; end

    require_relative './trigger/null_object'
    require_relative './trigger/parameters'
    require_relative './trigger/abstract_query'
    require_relative './trigger/trigger_query'
    require_relative './trigger/update_function_query'
    require_relative './trigger/integration'
  end
end

ActiveSupport.on_load :active_record do
  Statesman::Trigger::Integration.install!
end
