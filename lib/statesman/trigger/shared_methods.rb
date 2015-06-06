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

    # @api private
    module SharedMethods
      extend ActiveSupport::Concern

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
    end
  end
end
