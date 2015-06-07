module Statesman
  module Trigger
    # Generates `[ CREATE | DROP ] FUNCTION` statements.
    #
    # @api private
    class UpdateFunctionQuery < AbstractQuery
      up! <<-SQL
      CREATE OR REPLACE FUNCTION %<quoted_function_name>s() RETURNS TRIGGER AS $$
        BEGIN
          UPDATE %<model_table>s SET %<sync_column>s = NEW.to_state WHERE id = NEW.%<foreign_key_column>s;
          RETURN NULL;
        END;
      $$ LANGUAGE plpgsql;
      SQL

      down! <<-SQL
      DROP FUNCTION IF EXISTS %<quoted_function_name>s()
      SQL
    end
  end
end
