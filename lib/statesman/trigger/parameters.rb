module Statesman
  module Trigger
    # This generates `CREATE` / `DROP` `FUNCTION` / `TRIGGER` statements and can
    # introspect proper values based on provided {#model_klass} and {#transition_klass}.
    class Parameters
      __send__ :include, Virtus.model

      # @see #prefix
      PREFIX_FORMAT = "sync_%<state_name>s_state_for_%<model_table>s"

      # @!attribute [r] state_name
      # Unique identifier in the case of multiple states on the same table.
      # @return [String]
      attribute :state_name,          String, default: "statesman"

      # @!attribute [r] sync_column
      # The name of the column on the "parent" table to synchronize the last state's value.
      # @return [String]
      attribute :sync_column,         String, default: "current_state"

      # @!attribute [r] model_klass
      # The "parent" class that has the state machine on it.
      # @return [Class]
      attribute :model_klass,         Object, required: false, default: :default_model_klass

      # @!attribute [r] transition_klass
      # The transition class that stores the state machine history.
      # @return [Class]
      attribute :transition_klass,    Object, required: false, default: :default_transition_klass

      # @!attribute [r] model_table
      # The table for {#model_klass} (will be introspected from that if not provided, else error)
      # @return [String]
      attribute :model_table,         String, default: :default_model_table

      # @!attribute [r] transition_table
      # The table for {#transition_klass} (will be introspected from that if not provided, else error)
      # @return [String]
      attribute :transition_table,    String, default: :default_transition_table

      # @!attribute [r] foreign_key_column
      # The foreign key column on on {#transition_table} that syncs up with {#model_table}'s `id` column.
      #
      # Given `orders` and `order_transitions`, this would be `order_id` on the latter table.
      # @return [String]
      attribute :foreign_key_column,  String, default: :default_foreign_key_column

      # @!attribute [r] prefix
      # Used to namespace {#function_name} and {#trigger_name} in the database.
      # @see PREFIX_FORMAT
      # @return [String]
      attribute :prefix,              String, default: :default_prefix

      # @!attribute [r] function_name
      # @return [String]
      attribute :function_name,       String, default: :default_function_name

      # @!attribute [r] trigger_name
      # @return [String]
      attribute :trigger_name,        String, default: :default_trigger_name

      # Builds a query used to validate that {#sync_column} actually exists on {#model_table}.
      # @return [String]
      def build_validation_query
        %[SELECT TRUE from pg_attribute WHERE attrelid = '%<model_table>s'::regclass AND attname = '%<sync_column>s' AND NOT attisdropped] % { model_table: escape_string(model_table), sync_column: escape_string(sync_column) }
      end

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

      # @return [String]
      def inspect
        %[Statesman::Trigger(#{for_inspect.inspect})]
      end

      # @!attribute [r] quoted_function_name
      # Returns the PG-safe {#function_name}
      # @return [String]
      def quoted_function_name
        quote_ident function_name
      end

      # @!attribute [r] quoted_function_name
      # Returns the PG-safe {#trigger_name}
      # @return [String]
      def quoted_trigger_name
        quote_ident trigger_name
      end

      # @!attribute [r] update_function
      # @return [Statesman::Trigger::UpdateFunctionQuery]
      def update_function
        @update_function ||= UpdateFunctionQuery.new self
      end

      # @!attribute [r] trigger_statement
      # @return [Statesman::Trigger::TriggerQuery]
      def trigger_statement
        @trigger_statement ||= TriggerQuery.new self
      end

      # @return [Hash]
      def for_query
        attributes.slice(:state_name, :sync_column,
                         :model_table, :transition_table,
                         :function_name, :trigger_name,
                         :foreign_key_column).merge(
                           quoted_function_name:  quoted_function_name,
                           quoted_trigger_name:   quoted_trigger_name
                         )
      end

      # @return [Hash]
      def for_inspect
        attributes.slice(:state_name, :sync_column, :model_table, :transition_table)
      end

      private
      # @return [NullObject]
      def default_model_klass
        NullObject.new :model_klass
      end

      # @return [NullObject]
      def default_transition_klass
        NullObject.new :transition_klass
      end

      # @return [String]
      def default_prefix
        sprintf(PREFIX_FORMAT, state_name: state_name, model_table: model_table)
      end

      # @return [String]
      def default_model_table
        model_klass.table_name
      end

      # @return [String]
      def default_transition_table
        transition_klass.table_name
      end

      # @return [String]
      def default_foreign_key_column
        return "#{model_klass.model_name.singular}_id" unless model_klass.kind_of?(NullObject)

        return "#{model_table.to_s.singularize}_id"
      end

      # @return [String]
      def default_function_name
        "#{prefix}_fn"
      end

      # @return [String]
      def default_trigger_name
        "#{prefix}_trigger"
      end

      # @!group Quoting methods

      # Shorthand for `PG::Connection.escape_string`
      #
      # @param [String] value
      # @return [String]
      def escape_string(value)
        PG::Connection.escape_string value
      end

      # Shorthand for `PG::Connection.quote_ident`
      #
      # @param [String] value
      # @return [String]
      def quote_ident(value)
        PG::Connection.quote_ident value
      end
      # @!endgroup
    end
  end
end
