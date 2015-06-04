module Statesman
  module Trigger
    class Parameters
      include Virtus.model

      PREFIX_FORMAT = "sync_%<state_name>s_state_for_%<model_table>s"

      attribute :state_name,          String, default: "statesman"
      attribute :sync_column,         String, default: "current_state"

      attribute :model_klass,         Object, required: false, default: :default_model_klass
      attribute :transition_klass,    Object, required: false, default: :default_transition_klass

      attribute :model_table,         String, default: :default_model_table
      attribute :transition_table,    String, default: :default_transition_table
      attribute :foreign_key_column,  String, default: :default_foreign_key_column

      attribute :prefix,              String, default: :default_prefix

      attribute :function_name,       String, default: :default_function_name
      attribute :trigger_name,        String, default: :default_trigger_name

      # @return [String]
      def build_validation_query
        %[SELECT TRUE from pg_attribute WHERE attrelid = '%<model_table>s'::regclass AND attname = '%<sync_column>s' AND NOT attisdropped] % { model_table: escape_string(model_table), sync_column: escape_string(sync_column) }
      end

      # @api private
      # @param [:up, :down] direction
      # @return [<String>]
      def build_statements(direction:)
        stmts = []

        case direction
        when :up
          stmts << update_function.up
          stmts << trigger_statement.up
        when :down
          stmts << trigger_statement.down
          stmts << update_function.down
        end

        return stmts
      end

      def update_function
        @update_function ||= UpdateFunctionQuery.new self
      end

      def trigger_statement
        @trigger_statement ||= TriggerQuery.new self
      end

      # @return [Hash]
      def for_query
        attributes.slice(:state_name, :sync_column,
                         :model_table, :transition_table,
                         :function_name, :trigger_name,
                         :foreign_key_column)
      end

      private
      def default_model_klass
        NullObject.new :model_klass
      end

      def default_transition_klass
        NullObject.new :transition_klass
      end

      def default_prefix
        sprintf(PREFIX_FORMAT, state_name: state_name, model_table: model_table)
      end

      def default_model_table
        model_klass.table_name
      end

      def default_transition_table
        transition_klass.table_name
      end

      def default_foreign_key_column
        return "#{model_klass.model_name.singular}_id" unless model_klass.kind_of?(NullObject)

        return "#{model_table.to_s.singularize}_id"
      end

      def default_function_name
        quote_ident "#{prefix}_fn"
      end

      def default_trigger_name
        quote_ident "#{prefix}_trigger"
      end

      def escape_string(value)
        PG::Connection.escape_string value
      end

      def quote_ident(value)
        PG::Connection.quote_ident value
      end
    end
  end
end
