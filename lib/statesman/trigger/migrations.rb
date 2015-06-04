module Statesman
  module Trigger
    MATCH_STATE_NAME = proc do |args|
      args.length == 1 && args.first.kind_of?(String)
    end

    MATCH_MODEL_AND_TRANSITION_CLASSES = proc do |args|
      args.length == 2 && args.all? { |a| a.kind_of? Class }
    end

    MATCH_MODEL_AND_TRANSITION_TABLES = proc do |args|
      args.length == 2 && args.all? { |a| a.kind_of?(String) || a.kind_of?(Symbol) }
    end

    MATCH_STATE_NAME_AND_CLASSES = proc do |args|
      MATCH_STATE_NAME[args.take(1)] && MATCH_MODEL_AND_TRANSITION_CLASSES[args.drop(1)]
    end

    MATCH_STATE_NAME_AND_TABLE_NAMES = proc do |args|
      MATCH_STATE_NAME[args.take(1)] && MATCH_MODEL_AND_TRANSITION_TABLES[args.drop(1)]
    end

    # Integrates with CommandRecorder
    #
    # @api private
    module Migrations
      extend ActiveSupport::Concern

      def create_statesman_trigger(*args, &block)
        record :create_statesman_trigger, build_statesman_trigger_options(args)
      end

      def drop_statesman_trigger(*args, &block)
        record :drop_statesman_trigger, build_statesman_trigger_options(args)
      end

      def invert_create_statesman_trigger(args, &block)
        [:drop_statesman_trigger, build_statesman_trigger_options(args)]
      end

      def invert_drop_statesman_trigger(args, &block)
        [:create_statesman_trigger, build_statesman_trigger_options(args)]
      end

      def build_statesman_trigger_options(args)
        options = args.extract_options!

        case args
        when MATCH_STATE_NAME_AND_CLASSES
          options[:state_name]        = args.shift
          options[:model_klass]       = args.shift
          options[:transition_klass]  = args.shift
        when MATCH_STATE_NAME_AND_TABLE_NAMES
          options[:state_name]        = args.shift
          options[:model_table]       = args.shift
          options[:transition_table]  = args.shift
        when MATCH_STATE_NAME
          options[:state_name]        = args.shift
        when MATCH_MODEL_AND_TRANSITION_TABLES
          options[:model_table]       = args.shift
          options[:transition_table]  = args.shift
        when MATCH_MODEL_AND_TRANSITION_CLASSES
          options[:model_klass]       = args.shift
          options[:transition_klass]  = args.shift
        end

        return [options]
      end
    end
  end
end
