module Statesman
  module Trigger
    module Integration
      # Used to match a single string for a {Parameters#state_name}
      MATCH_STATE_NAME = proc do |args|
        args.length == 1 && args.first.kind_of?(String)
      end

      # Used to match a tuple of classes for {Parameters#model_klass} and {Parameters#transition_klass}
      MATCH_MODEL_AND_TRANSITION_CLASSES = proc do |args|
        args.length == 2 && args.all? { |a| a.kind_of? Class }
      end

      # Used to match a tuple of strings for {Parameters#model_table} and {Parameters#transition_table}
      MATCH_MODEL_AND_TRANSITION_TABLES = proc do |args|
        args.length == 2 && args.all? { |a| a.kind_of?(String) || a.kind_of?(Symbol) }
      end

      # Combines {MATCH_STATE_NAME} with {MATCH_MODEL_AND_TRANSITION_CLASSES}
      MATCH_STATE_NAME_AND_CLASSES = proc do |args|
        MATCH_STATE_NAME[args.take(1)] && MATCH_MODEL_AND_TRANSITION_CLASSES[args.drop(1)]
      end

      # Combines {MATCH_STATE_NAME} with {MATCH_MODEL_AND_TRANSITION_TABLES}
      MATCH_STATE_NAME_AND_TABLE_NAMES = proc do |args|
        MATCH_STATE_NAME[args.take(1)] && MATCH_MODEL_AND_TRANSITION_TABLES[args.drop(1)]
      end

      # Methods used by migration and connection adapter integrations.
      #
      # @api private
      module SharedMethods
        extend ActiveSupport::Concern

        # @!macro [new] migration_options
        #   @param [Hash] options
        #   @option options [String] :sync_column (see Parameters#sync_column)

        # @!macro [new] migration_command
        #   @overload $0(state_name, options = {})
        #     @param [#to_s] state_name
        #     @!macro migration_options
        #   @overload $0(model_klass, transition_klass, options = {})
        #     @param [Class] model_klass
        #     @param [Class] transition_klass
        #     @!macro migration_options
        #   @overload $0(state_name, model_klass, transition_klass, options = {})
        #     @param [#to_s] state_name
        #     @param [Class] model_klass
        #     @param [Class] transition_klass
        #     @!macro migration_options
        #   @overload $0(model_table, transition_table, options = {})
        #     @param [#to_s] model_table
        #     @param [#to_s] transition_table
        #     @!macro migration_options
        #   @overload $0(state_name, model_table, transition_table, options = {})
        #     @param [#to_s] state_name
        #     @param [#to_s] model_table
        #     @param [#to_s] transition_table
        #     @!macro migration_options
        #
        #   @return [void]

        # @param [(Class, Class), (#to_s, #to_s, #to_s), (#to_s), (#to_s, Class, Class), (#to_s, #to_s)] args
        # @return [(Hash)]
        def build_statesman_trigger_options(args)
          return [args.first] if args.first.kind_of?(Statesman::Trigger::Parameters)

          args    &&= args.dup
          options = args.extract_options!

          case args
          when MATCH_STATE_NAME_AND_CLASSES
            options[:state_name], options[:model_klass], options[:transition_klass] = args
          when MATCH_STATE_NAME_AND_TABLE_NAMES
            options[:state_name], options[:model_table], options[:transition_table] = args
          when MATCH_STATE_NAME
            options[:state_name] = args.first
          when MATCH_MODEL_AND_TRANSITION_TABLES
            options[:model_table], options[:transition_table] = args
          when MATCH_MODEL_AND_TRANSITION_CLASSES
            options[:model_klass], options[:transition_klass] = args
          end

          return [options]
        end

        # @param (see #build_statesman_trigger_options)
        # @return [Statesman::Trigger::Parameters]
        def build_statesman_trigger_params(args)
          Statesman::Trigger::Parameters.new build_statesman_trigger_options(args).first
        end
      end
    end
  end
end
